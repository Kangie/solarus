// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QMap>
#include <QObject>
#include <QPointer>
#include <QColor>

namespace solarus::launcher {
class QuestOutputHandler : public QObject {
  Q_OBJECT

public:
  struct Theme {
    QColor debugColor{ 255, 255, 255, 127 };
    QColor infoColor{ 126, 160, 255 };
    QColor warningColor{ 255, 188, 0 };
    QColor errorColor{ 252, 72, 80 };
    QColor fatalColor{ 252, 72, 80 };

    bool operator==(const Theme& other) const;
    bool operator!=(const Theme& other) const;
  };

  QuestOutputHandler(QObject* parent = nullptr);
  ~QuestOutputHandler();

public:
  const Theme& theme() const;
  void setTheme(const Theme& theme);
  Q_SIGNAL void themeChanged();

  void onOutputProduced(const QStringList& lines);
  void onStateChanged(bool playing);

private:
  void parseAndPrintLine(const QString& line);
  bool detectCommandResult(const QString& logLevel, const QString& message);
  void detectSettingChange(const QString& logLevel, const QString& message);
  QString colorizeOutput(const QString& logLevel, const QString& message) const;
  QString colorize(const QString& line, const QString& color) const;

signals:
  void htmlProduced(const QString& html);
  void commandResultReceived(int id, const QString& command, bool success, const QString& result);
  void questSettingChanged(const QString& key, const QVariant& value);
  void outputCleared();
  void outputColorsChanged();

private:
  QMap<int, QString> _pendingCommands;
  int _outputCommandId = -1;
  QString _outputCommandResult;
  bool _commandEnabled{ false };
  Theme _theme;
};
} // namespace solarus::launcher
