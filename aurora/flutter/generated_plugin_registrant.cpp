//
//  Generated file. Do not edit.
//

// clang-format off
#include <filesystem>
#include <iostream>

#include <appdir.h>
#include <dlfcn.h>
#include <path_provider_aurora/plugin.h>
#include <sqflite_aurora/plugin.h>

#include "generated_plugin_registrant.h"

namespace aurora {

namespace {

constexpr const char* dart_entry_point = nullptr;
constexpr const char* dart_entry_point_library = nullptr;
constexpr const char* cover_entry_point = nullptr;
constexpr const char* cover_entry_point_library = nullptr;
constexpr const char* organization = "com.example";
constexpr const char* project_name = "vitmus";

void RegisterPluginsImpl(FlutterAuroraPluginContext* context, void* user_data) {
  PathProviderAuroraPluginRegister(context);
  SqfliteAuroraPluginRegisterWithRegistrar(context);

  if (user_data) {
    auto* self = reinterpret_cast<FlutterApp*>(user_data);
    self->OnRegisterPlugins(context);
  }
}

std::filesystem::path GetBundleDir(const std::string& binary_name) {
  if (auto* base = appdir_get_path(PackageFilesLocation)) {
    const auto directory = std::filesystem::path(base);
    if (std::filesystem::exists(directory)) {
      return directory;
    }
  }

  std::cout << "[warn] Appdir did not provide bundle directory, using fallback" << std::endl;

  const auto directory =
    std::filesystem::path("/") / "opt" / "app" / binary_name / "current" / "data";

  if (!std::filesystem::exists(directory)) {
    std::cout << "[crit] Couldn't find application bundle directory" << std::endl;
    std::exit(1);
  }

  return directory;
}

std::filesystem::path GetEmbedderLibPath(const std::string& binary_name) {
  return GetBundleDir(binary_name) / "lib" / "libaurora_embedder.so";
}

}  // anonymous namespace

FlutterApp::FlutterApp(int argc, char* argv[]) {
  GetProcAddresses FlutterAuroraGetProcAddresses = GetAuroraProcAddresses(std::filesystem::path(argv[0]).filename());

  if (!FlutterAuroraGetProcAddresses) {
    std::cout << "[crit] couldn't load flutter method: GetProcAddresses" << std::endl;
    std::exit(1);
  }

  if (FlutterAuroraGetProcAddresses(&api_, sizeof(FlutterAuroraProcTable)) == kFA_Result_Success) {
    if (api_.Initialize == nullptr) {
      std::cout << "[crit] Function Initialize() is not exists." << std::endl;
      std::exit(1);
    }
    if (api_.Release == nullptr) {
      std::cout << "[crit] Function Release() is not exists." << std::endl;
      std::exit(1);
    }
    application_ = api_.Initialize(argc, argv);
    if (application_ == nullptr) {
      std::cout << "[crit] Application is not created." << std::endl;
      std::exit(1);
    }
  } else {
    std::cout << "[crit] Cannot load api table" << std::endl;
    std::exit(1);
  }
}

FlutterApp::~FlutterApp() {
  if (application_ != nullptr) {
    if (api_.Release != nullptr) {
      api_.Release(application_);
    }
    application_ = nullptr;
  }
  if (library_handle_) {
    dlclose(library_handle_);
    library_handle_ = nullptr;
  }
}

int FlutterApp::exec(const std::string& entry_point,
                     FlutterAuroraGuiType gui_type,
                     uint32_t flags) {
  if (api_.Exec == nullptr) {
    std::cout << "[crit] Function Exec() is not exists." << std::endl;
    std::exit(1);
  }
  if (api_.ExecOptionsInitDefault == nullptr) {
    std::cout << "[crit] Function ExecOptionsInitDefault() is not exists." << std::endl;
    std::exit(1);
  }


  FlutterAuroraExecOptions options;
  api_.ExecOptionsInitDefault(&options, sizeof(FlutterAuroraExecOptions));
  if (!entry_point.empty()) {
    options.dart_entry_point = entry_point.c_str();
  } else {
    options.dart_entry_point = dart_entry_point;
    options.dart_entry_point_library = dart_entry_point_library;
  }
  options.cover_entry_point = cover_entry_point;
  options.cover_entry_point_library = cover_entry_point_library;
  options.gui_type = gui_type;
  options.flags = flags;
  options.plugins_register_callback = RegisterPluginsImpl;
  options.user_data = this;

  return api_.Exec(application_, &options);
}

void FlutterApp::OnRegisterPlugins(FlutterAuroraPluginContext* /*context*/) {
}

FlutterApp::GetProcAddresses FlutterApp::GetAuroraProcAddresses(const std::string& binary_name) {
  const auto embedder_lib = GetEmbedderLibPath(binary_name);

  library_handle_ = dlopen(embedder_lib.c_str(), RTLD_LOCAL | RTLD_NOW);
  if (!library_handle_) {
    std::cout << "[crit] Could not load embedder library." << std::endl;
    std::exit(1);
  }

  void* symbol = dlsym(library_handle_, "FlutterAuroraGetProcAddresses");
  return reinterpret_cast<GetProcAddresses>(symbol);
}

}  // namespace aurora

// clang-format on


