// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QObject>
#include <QProcess>
#include <QTimer>

#include "QuestOutputHandler.h"

namespace solarus::launcher {
class QuestRunner : public QObject {
  Q_OBJECT

public:
  enum class State {
    Stopped,
    Starting,
    Running,
  };
  Q_ENUM(State)

  enum class ErrorCode {
    NoError,
    UnknownError,
    ProcessFailedToStart,
    ProcessCrashed,
    ProcessWriteError,
    ProcessReadError,
    ProcessTimedOut,
  };
  Q_ENUM(ErrorCode)

  explicit QuestRunner(QObject* parent = nullptr);
  ~QuestRunner();

public:
  State state() const;
  const QString& questFilePath() const;
  QuestOutputHandler& outputHandler() const;
  const QString& fullOutput() const;

public:
  bool audioEnabled() const;
  void setAudioEnabled(bool);

  bool forceSoftwareRendering() const;
  void setForceSoftwareRendering(bool);

  bool fullScreen() const;
  void setFullScreen(bool);

  bool suspendWhenUnfocused() const;
  void setSuspendWhenUnfocused(bool);

public slots:
  void start(const QString& questFilePath);
  void stop();
  int executeCommand(const QString& command);

private slots:
  void onProcessError(QProcess::ProcessError error);
  void onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
  void onProcessStandardOutputAvailable();
  void onProcessStateChanged(QProcess::ProcessState state);
  void onTimerTimeout();

signals:
  void aboutToStop();
  void stateChanged();
  void errorRaised(ErrorCode error);
  void questChanged();

private:
  std::pair<QString, QStringList> createArguments(const QString& questPath) const;

private:
  QProcess _process;
  QuestOutputHandler _questOutputHandler;
  QString _questFullOutput;
  QTimer _timer;
  int _lastCommandId{ -1 };
  QString _questFilePath;
  bool _audioEnabled{ true };
  bool _forceSoftwareRendering{ false };
  bool _fullScreen{ false };
  bool _suspendWhenUnfocused{ true };
};
} // namespace solarus::launcher
