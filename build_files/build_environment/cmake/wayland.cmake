# SPDX-License-Identifier: GPL-2.0-or-later

ExternalProject_Add(external_wayland
  URL file://${PACKAGE_DIR}/${WAYLAND_FILE}
  DOWNLOAD_DIR ${DOWNLOAD_DIR}
  URL_HASH ${WAYLAND_HASH_TYPE}=${WAYLAND_HASH}
  PREFIX ${BUILD_DIR}/wayland
  PATCH_COMMAND ${PATCH_CMD} -d ${BUILD_DIR}/wayland/src/external_wayland < ${PATCH_DIR}/wayland.diff
  # Use `-E` so the `PKG_CONFIG_PATH` can be defined to link against our own LIBEXPAT & LIBXML2.
  # Note that passing link args "ffi/lib" should not be needed, but
  # `pkgconfig` would incorrectly look in "ffi/lib/../lib64" otherwise.
  CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env PKG_CONFIG_PATH=${LIBDIR}/expat/lib/pkgconfig:${LIBDIR}/xml2/lib/pkgconfig:${LIBDIR}/ffi/lib/pkgconfig:$PKG_CONFIG_PATH
                    meson --prefix ${LIBDIR}/wayland -Ddocumentation=false -Dtests=false -Dc_link_args=-L${LIBDIR}/ffi/lib . ../external_wayland
  BUILD_COMMAND ninja
  INSTALL_COMMAND ninja install
)

add_dependencies(
  external_wayland
  external_expat
  external_xml2
  external_ffi
)
