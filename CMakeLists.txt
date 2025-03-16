cmake_minimum_required(VERSION 3.10)

# Android: version information must be updated manually in AndroidConfig.h
project(solarus-engine VERSION 2.0.0)

# Organize targets into folders for compatible generators, e.g. Xcode and Visual Studio.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

include(cmake/AddGitRevision.cmake)
include(cmake/AddOptions.cmake)
include(cmake/AddCompilationFlags.cmake)
include(cmake/AddCodeCoverage.cmake)
include(cmake/AddDependencies.cmake)
include(cmake/AddDefines.cmake)
include(cmake/AddConfigurationHeader.cmake)
include(cmake/AddSolarusLibrary.cmake)
include(cmake/AddSolarusExecutable.cmake)
include(cmake/AddInstallTargets.cmake)
include(cmake/AddUninstallTargets.cmake)
include(cmake/AddUnitTests.cmake)
include(cmake/AddGui.cmake)
