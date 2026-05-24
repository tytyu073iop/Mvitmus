//
//  Generated file. Do not edit.
//

// clang-format off

#ifndef GENERATED_PLUGIN_REGISTRANT
#define GENERATED_PLUGIN_REGISTRANT

#include <string>

#include <flutter_aurora/defs.h>
#include <flutter_aurora/engine_api.h>
#include <flutter_aurora/flutter_aurora.h>

namespace aurora {

class FlutterApp {
 public:
  FlutterApp(int argc, char* argv[]);
  virtual ~FlutterApp();

  int exec(const std::string& entry_point = std::string(),
           FlutterAuroraGuiType gui_type = kFA_GuiType_Enabled,
           uint32_t flags = 0);

  virtual void OnRegisterPlugins(FlutterAuroraPluginContext* context);

 protected:
  FlutterAuroraApplicationRef application_ = nullptr;
  FlutterAuroraProcTable api_;

 private:
  using GetProcAddresses =
      FlutterAuroraResult (*)(FlutterAuroraProcTable* table, size_t struct_size);
  void* library_handle_ = nullptr;
  GetProcAddresses GetAuroraProcAddresses(const std::string& binary_name);
};

}  // namespace aurora

#endif /* GENERATED_PLUGIN_REGISTRANT */

// clang-format on

