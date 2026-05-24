#
# Generated file, do not edit.
#
set(ROOT_PROJECT_BINARY_DIR "${PROJECT_BINARY_DIR}")

find_package(PkgConfig REQUIRED)
pkg_check_modules(AppDir REQUIRED IMPORTED_TARGET appdir-cpp)

target_sources(${BINARY_NAME} PRIVATE ${FLUTTER_DIR}/generated_plugin_registrant.cpp)
target_link_libraries(${BINARY_NAME} PRIVATE
    aurora_embedder::aurora_embedder
    PkgConfig::AppDir
)

target_include_directories(${BINARY_NAME} PRIVATE
    ${FLUTTER_DIR}
)

function(add_library TARGET)
    _add_library(${TARGET} ${ARGN})

    if (
      "${TARGET}" MATCHES "^path_provider_aurora_platform_plugin$" OR
      "${TARGET}" MATCHES "^sqflite_aurora_platform_plugin$" OR
      FALSE
    )
      add_custom_command(TARGET ${TARGET} POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -E copy
                        "$<TARGET_FILE:${TARGET}>"
                        "${ROOT_PROJECT_BINARY_DIR}/bundle/lib/$<TARGET_FILE_NAME:${TARGET}>")
    endif()
endfunction()

list(APPEND FLUTTER_NATIVE_LIBS_LIST
    aurora_client_wrapper
    aurora_embedder
)

list(APPEND FLUTTER_PLATFORM_PLUGIN_LIST
    path_provider_aurora
    sqflite_aurora
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
)

foreach(NATIVE_LIB ${FLUTTER_NATIVE_LIBS_LIST})
  list(APPEND CMAKE_MODULE_PATH "/home/ilya/Documents/work/Android/Mvitmus/aurora/flutter/ephemeral/.aurora_plugin_symlinks/${NATIVE_LIB}/aurora")
endforeach(NATIVE_LIB)

set(AURORA_EMBEDDER_AS_INTERFACE ON)
if(NOT TARGET aurora_embedder::aurora_embedder)
    find_package(aurora_embedder REQUIRED)
endif()

foreach(PLUGIN ${FLUTTER_PLATFORM_PLUGIN_LIST})
    add_subdirectory(flutter/ephemeral/.aurora_plugin_symlinks/${PLUGIN}/aurora plugins/${PLUGIN})
    target_link_libraries(${BINARY_NAME} PRIVATE ${PLUGIN}_platform_plugin)
endforeach(PLUGIN)

foreach(FFI_PLUGIN ${FLUTTER_FFI_PLUGIN_LIST})
    add_subdirectory(flutter/ephemeral/.aurora_plugin_symlinks/${FFI_PLUGIN}/aurora plugins/${FFI_PLUGIN})
endforeach(FFI_PLUGIN)
