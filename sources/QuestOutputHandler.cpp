// SPDX-License-Identifier: GPL-3.0-or-later
#include "QuestOutputHandler.h"

#include <QDebug>
#include <QLoggingCategory>
#include <QRegularExpression>

namespace solarus::launcher {
Q_LOGGING_CATEGORY(LOGCAT_QUESTOUTPUTHANDLER, "solarus.launcher.QuestOutputHandler")

namespace {
constexpr auto OUTPUT_REGEXP = "^\\[Solarus\\] \\[(\\d+)\\] (\\w*): (.+)$";
constexpr auto OUTPUT_COMMAND_RESULT_BEGIN_REGEXP = "^====== Begin Lua command #(\\d+) ======$";
constexpr auto OUTPUT_COMMAND_RESULT_END_REGEXP = "^====== End Lua command #(\\d+): (\\w+) ======$";
constexpr auto OUTPUT_SIMPLIFY_CONSOLE_ERROR_REGEXP = "In Lua command: \\[string \".*\"\\]:\\d+: ";
constexpr auto OUTPUT_SETTING_FULLSCREEN_REGEXP = "^Fullscreen: (\\w+)$";

constexpr auto LOGLEVEL_DEBUG = "Debug";
constexpr auto LOGLEVEL_INFO = "Info";
constexpr auto LOGLEVEL_WARNING = "Warning";
constexpr auto LOGLEVEL_ERROR = "Error";
constexpr auto LOGLEVEL_FATAL = "Fatal";
} // namespace

QuestOutputHandler::QuestOutputHandler(QObject* parent)
  : QObject(parent) {}

QuestOutputHandler::~QuestOutputHandler() = default;

const QuestOutputHandler::Theme& QuestOutputHandler::theme() const {
  return _theme;
}

void QuestOutputHandler::setTheme(const Theme& theme) {
  if (_theme != theme) {
    _theme = theme;
    emit themeChanged();
  }
}

void QuestOutputHandler::onOutputProduced(const QStringList& lines) {
  for (const auto& line : lines) {
    parseAndPrintLine(line);
  }
}

void QuestOutputHandler::onStateChanged(bool playing) {
  if (!playing) {
    emit outputCleared();
  }
}

void QuestOutputHandler::parseAndPrintLine(const QString& line) {
  static const QRegularExpression output_regexp("^\\[Solarus\\] \\[(\\d+)\\] (\\w*): (.+)$");
  static const QRegularExpression output_simplify_console_error_regexp(OUTPUT_SIMPLIFY_CONSOLE_ERROR_REGEXP);

#ifdef QT_DEBUG
  qDebug().noquote() << line;
#endif

  if (line.isEmpty()) {
    return;
  }

  QString logLevel;
  QString message = line;
  const auto matchResult = output_regexp.match(line);

  // 4 captures expected: full line, time, log level, message.
  if (matchResult.hasMatch()) {
    const auto captures = matchResult.capturedTexts();
    if (captures.size() != 4) {
      emit htmlProduced(line.toHtmlEscaped());
      return;
    }

    logLevel = captures[2];
    message = captures[3];
  }

  // Solarus produced an empty message just to flush its stdout.
  if (!logLevel.isEmpty() && message.isEmpty()) {
    return;
  }

  // Detect technical delimiters of commands output but don't show them.
  if (detectCommandResult(logLevel, message)) {
    return;
  }

  // Not a line from Solarus, probably one from the quest or Qt.
  if (logLevel.isEmpty()) {
    emit htmlProduced(line.toHtmlEscaped());
    return;
  }

  // Report system setting changes.
  detectSettingChange(logLevel, message);

  // Clean specific error messages.
  if (logLevel == LOGLEVEL_ERROR) {
    message.remove(output_simplify_console_error_regexp);
  }

  // Add color.
  const auto htmlLine = colorizeOutput(logLevel, message);
  if (htmlLine.isEmpty()) {
    return;
  }

  // Emit signal to tell the GUI that html is ready.
  emit htmlProduced(htmlLine);
}

bool QuestOutputHandler::detectCommandResult(const QString& logLevel, const QString& message) {
  static const QRegularExpression output_command_result_begin_regexp(OUTPUT_COMMAND_RESULT_BEGIN_REGEXP);
  static const QRegularExpression output_command_result_end_regexp(OUTPUT_COMMAND_RESULT_END_REGEXP);

  QRegularExpressionMatch matchResult;

  // Detect the beginning of a console command result.
  matchResult = output_command_result_begin_regexp.match(message);
  if (logLevel == LOGLEVEL_INFO && matchResult.lastCapturedIndex() == 1) {
    // Start of a command result.
    if (_outputCommandId != -1) {
      qCWarning(LOGCAT_QUESTOUTPUTHANDLER) << "Beginning of a command result inside another command result";
    }

    _outputCommandId = matchResult.captured(1).toInt();
    _outputCommandResult.clear();

    // Show the command in the log view.
    // We show the command only when receiving its results,
    // to make sure it is displayed just before its results.
    const auto command = _pendingCommands.take(_outputCommandId);
    emit htmlProduced(QStringLiteral("> %1").arg(command).toHtmlEscaped());

    return true;
  }

  // Detect the end of a console command result.
  matchResult = output_command_result_end_regexp.match(message);
  if (logLevel == LOGLEVEL_INFO && matchResult.lastCapturedIndex() == 2) {
    // End of a command result.
    if (_outputCommandId == -1) {
      qCWarning(LOGCAT_QUESTOUTPUTHANDLER) << "End of a command result without beginning";
      return false;
    }
    const auto id = matchResult.captured(1).toInt();
    const auto success = matchResult.captured(2) == "success";
    const auto command = _pendingCommands.take(_outputCommandId);
    const auto result = _outputCommandResult;

    if (id != _outputCommandId) {
      qCWarning(LOGCAT_QUESTOUTPUTHANDLER) << "Unmatched command delimiters";
    }

    _pendingCommands.remove(_outputCommandId);
    _outputCommandId = -1;
    _outputCommandResult.clear();

    emit commandResultReceived(id, command, success, result);

    return true;
  }

  // Process the current result between delimiters.
  if (_outputCommandId != -1) {
    // We are inside the delimiters.
    _outputCommandResult += message;
    // Let the console colorize and show the text normally.
    return false;
  }

  return false;
}

void QuestOutputHandler::detectSettingChange(const QString& logLevel, const QString& message) {
  static const QRegularExpression output_setting_fullscreen_regexp(OUTPUT_SETTING_FULLSCREEN_REGEXP);

  if (logLevel != LOGLEVEL_INFO) {
    return;
  }

  const auto match_result = output_setting_fullscreen_regexp.match(message);
  if (match_result.lastCapturedIndex() == 1) {
    const auto value = QVariant(match_result.captured(1) == "yes");
    emit questSettingChanged("quest_fullscreen", value);
  }
}

QString QuestOutputHandler::colorizeOutput(const QString& log_level, const QString& message) const {
  if (message.isEmpty()) {
    return message;
  }

  // Colorize warnings and errors.
  const auto decorated_line = QString("%1: %2").arg(log_level, message);
  if (log_level == LOGLEVEL_DEBUG) {
    return colorize(decorated_line, _theme.debugColor.name(QColor::HexArgb));
  } else if (log_level == LOGLEVEL_INFO) {
    return colorize(decorated_line, _theme.infoColor.name(QColor::HexArgb));
  } else if (log_level == LOGLEVEL_WARNING) {
    return colorize(decorated_line, _theme.warningColor.name(QColor::HexArgb));
  } else if (log_level == LOGLEVEL_ERROR) {
    return colorize(decorated_line, _theme.errorColor.name(QColor::HexArgb));
  } else if (log_level == LOGLEVEL_FATAL) {
    return colorize(decorated_line, _theme.fatalColor.name(QColor::HexArgb));
  } else {
    // Unknown log level.
    return message;
  }
}

QString QuestOutputHandler::colorize(const QString& line, const QString& color) const {
  static const auto templateStr = QString("<span style=\"color: %1\">%2</span>");
  return line.trimmed().isEmpty() ? "" : templateStr.arg(color, line.toHtmlEscaped());
}

bool QuestOutputHandler::Theme::operator==(const Theme& other) const {
  return debugColor == other.debugColor && infoColor == other.infoColor && warningColor == other.warningColor
         && errorColor == other.errorColor && fatalColor == other.fatalColor;
}

bool QuestOutputHandler::Theme::operator!=(const Theme& other) const {
  return !(*this == other);
}
} // namespace solarus::launcher
