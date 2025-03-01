#include <BasicUpdater.h>

#include <QDesktopServices>
#include <QApplication>

#include <QTimer>

namespace solarus::launcher {
void checkForUpdates(const std::function<void(const UpdateCheckResult&)>& onFinished) {

  UpdateCheckResult result {
    UpdateCheckStatus::UpdateAvailable,
    QVersionNumber::fromString(QApplication::applicationVersion()),
    QVersionNumber::fromString(QApplication::applicationVersion()),

  };

  QTimer::singleShot(3000, qApp, [onFinished, result](){
    onFinished(result);
  });
}
} //
