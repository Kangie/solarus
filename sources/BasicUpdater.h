// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <functional>

#include <QVersionNumber>
#include <QUrl>

namespace solarus::launcher {
enum class UpdateCheckStatus {
  NoUpdate,
  UpdateAvailable,
  Error,
};

struct UpdateCheckResult {
  UpdateCheckStatus status{UpdateCheckStatus::NoUpdate};
  QVersionNumber currentVersion;
  QVersionNumber newVersion;
  QUrl newVersionDownloadUrl;
  int errorCode{0};
};

void checkForUpdates(const std::function<void(const UpdateCheckResult&)>& onFinished);

void doUpdate();
} // namespace solarus::launcher
