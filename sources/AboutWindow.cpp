#include "AboutWindow.h"

#include "Utils.h"

#include <QApplication>
#include <QLabel>
#include <QBoxLayout>
#include <QPushButton>
#include <QDesktopServices>

#include <oclero/qlementine/widgets/Label.hpp>

namespace solarus::launcher {
namespace i18n {
static QString windowTitle() {
  return QApplication::translate("SolarusLauncher", "About %1");
}
static QString allRightsReserved() {
  return QApplication::translate("SolarusLauncher", "All rights reserved.");
}
static QString appDescription() {
  return QApplication::translate("SolarusLauncher", "A graphical user interface to launch and manage Solarus quests.");
}
static QString license() {
  return QApplication::translate("SolarusLauncher", "Licensed under GPL v3 and CC-BY-SA 4.0.");
}
} // namespace i18n

AboutWindow::AboutWindow(QWidget* parent)
  : QDialog(parent) {
  setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
  setWindowTitle(i18n::windowTitle().arg(QApplication::applicationDisplayName()));
  setWindowModality(Qt::WindowModality::ApplicationModal);
  setWindowFlag(Qt::WindowType::MSWindowsFixedSizeDialogHint, true);
  setWindowFlag(Qt::WindowType::WindowContextHelpButtonHint, false);
  setWindowFlag(Qt::WindowType::WindowMaximizeButtonHint, false);
  setWindowFlag(Qt::WindowType::WindowMinimizeButtonHint, false);
  setWindowFlag(Qt::WindowType::WindowFullscreenButtonHint, false);

  setupUi();
}

void AboutWindow::setupUi() {
  auto* rootLayout = new QVBoxLayout(this);
  rootLayout->setContentsMargins(32, 16, 32, 16);
  rootLayout->setSizeConstraint(QLayout::SizeConstraint::SetFixedSize);
  setLayout(rootLayout);

  // Logo, app name and version.
  {
    auto* iconLabel = new QLabel(this);
    iconLabel->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
    iconLabel->setFixedSize(64, 64);
    iconLabel->setScaledContents(true);
    iconLabel->setAlignment(Qt::AlignHCenter | Qt::AlignTop);
    iconLabel->setPixmap(QApplication::windowIcon().pixmap(iconLabel->height() * 2));

    auto iconLabelLayout = new QHBoxLayout();
    iconLabelLayout->addSpacerItem(new QSpacerItem(0, 0, QSizePolicy::Expanding, QSizePolicy::Fixed));
    iconLabelLayout->addWidget(iconLabel);
    iconLabelLayout->addSpacerItem(new QSpacerItem(0, 0, QSizePolicy::Expanding, QSizePolicy::Fixed));
    iconLabelLayout->setSizeConstraint(QLayout::SizeConstraint::SetFixedSize);

    auto* appInfoLayout = new QVBoxLayout();
    appInfoLayout->setContentsMargins(0, 0, 0, 0);
    appInfoLayout->setSpacing(2);

    auto* appNameLabel = new oclero::qlementine::Label(this);
    appNameLabel->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Fixed);
    appNameLabel->setRole(oclero::qlementine::TextRole::H4);
    appNameLabel->setText(QApplication::applicationDisplayName());
    appNameLabel->setAlignment(Qt::AlignCenter);

    auto* appVersionLabel = new QLabel(this);
    appVersionLabel->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Fixed);
    appVersionLabel->setText(QApplication::applicationVersion());
    appVersionLabel->setAlignment(Qt::AlignCenter);

    appInfoLayout->addWidget(appNameLabel);
    appInfoLayout->addWidget(appVersionLabel);

    rootLayout->addLayout(iconLabelLayout);
    rootLayout->addLayout(appInfoLayout);
  }

  // App description.
  {
    auto* appDescriptionLabel = new QLabel(this);
    appDescriptionLabel->setText(i18n::appDescription());
    appDescriptionLabel->setAlignment(Qt::AlignCenter);
    appDescriptionLabel->setWordWrap(true);
    appDescriptionLabel->setFixedWidth(250);
    appDescriptionLabel->setSizePolicy(QSizePolicy::MinimumExpanding, QSizePolicy::Preferred);
    rootLayout->addWidget(appDescriptionLabel);
    rootLayout->setAlignment(appDescriptionLabel, Qt::AlignHCenter);
  }

  rootLayout->addSpacerItem(new QSpacerItem(0, 16, QSizePolicy::Ignored, QSizePolicy::MinimumExpanding));

  // Links to social media.
  {
    auto* buttonsLayout = new QHBoxLayout();
    buttonsLayout->setSizeConstraint(QLayout::SizeConstraint::SetFixedSize);
    buttonsLayout->setSpacing(4);
    buttonsLayout->setContentsMargins(0, 0, 0, 0);
    for (const auto [tooltip, url, icon] : {
           std::make_tuple("X", PROJECT_LINKS_X, Icons16::Brand_X),
           std::make_tuple("Mastodon", PROJECT_LINKS_MASTODON, Icons16::Brand_MastodonFill),
           std::make_tuple("YouTube", PROJECT_LINKS_YOUTUBE, Icons16::Brand_YoutubeFill),
         }) {
      auto* button = new QPushButton(this);
      button->setIcon(makeIcon(icon));
      button->setFocusPolicy(Qt::NoFocus);
      button->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
      button->setToolTip(tooltip);
      button->setFlat(true);
      button->setCursor(QCursor(Qt::CursorShape::PointingHandCursor));
      const auto button_url = QUrl(url);
      QObject::connect(button, &QPushButton::clicked, button, [button_url]() {
        QDesktopServices::openUrl(button_url);
      });
      buttonsLayout->addWidget(button);
    }

    rootLayout->addLayout(buttonsLayout);
    rootLayout->setAlignment(buttonsLayout, Qt::AlignHCenter);

    // Legal information.
    {
      auto prettyUrl = QString(PROJECT_HOMEPAGE_URL);
      if (prettyUrl.startsWith("https://")) {
        prettyUrl.remove(0, 8);
      }

      auto* websiteLabel = new oclero::qlementine::Label(this);
      websiteLabel->setText(QString("<a href=\"%1\">%2</a>").arg(PROJECT_HOMEPAGE_URL, prettyUrl));
      websiteLabel->setAlignment(Qt::AlignCenter);

      auto* licenseLabel = new oclero::qlementine::Label(this);
      licenseLabel->setRole(oclero::qlementine::TextRole::Caption);
      licenseLabel->setText(QApplication::applicationDisplayName());
      licenseLabel->setAlignment(Qt::AlignCenter);
      licenseLabel->setText(i18n::license());

      auto* copyrightLabel = new oclero::qlementine::Label(this);
      copyrightLabel->setRole(oclero::qlementine::TextRole::Caption);
      copyrightLabel->setText(QApplication::applicationDisplayName());
      copyrightLabel->setAlignment(Qt::AlignCenter);
      const auto copyrightText = QString("%1 %2").arg(PROJECT_APP_COPYRIGHT, i18n::allRightsReserved());
      copyrightLabel->setText(copyrightText);

      auto* smallTextsLayout = new QVBoxLayout();
      smallTextsLayout->setContentsMargins(0, 0, 0, 0);
      smallTextsLayout->setSpacing(2);
      smallTextsLayout->addWidget(licenseLabel);
      smallTextsLayout->setAlignment(licenseLabel, Qt::AlignHCenter);

      smallTextsLayout->addWidget(copyrightLabel);
      smallTextsLayout->setAlignment(copyrightLabel, Qt::AlignHCenter);

      rootLayout->addWidget(websiteLabel);
      rootLayout->setAlignment(websiteLabel, Qt::AlignHCenter);

      rootLayout->addLayout(smallTextsLayout);
    }
  }
}
} // namespace solarus::launcher
