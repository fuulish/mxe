# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wine
$(PKG)_WEBSITE  := https://github.com/fuulish/wine
$(PKG)_DESCR    := WINE
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4035623
$(PKG)_CHECKSUM := 367ea0fdeb92ca36ee1f731159d9b0dcd2c2eef789b91a95a1211acc6203c94e
$(PKG)_GH_CONF  := fuulish/wine/branches/master
$(PKG)_DEPS     := cc gnutls

define $(PKG)_BUILD
    # build and install the library
    mkdir '$(BUILD_DIR)/tooldir' && cd '$(BUILD_DIR)/tooldir' && \
	    $(SOURCE_DIR)/configure --without-freetype --without-x --without-gnutls && \
	    $(MAKE) -C '$(BUILD_DIR)/tooldir' -j$(JOBS) __tooldeps__

    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) --with-wine-tools='$(BUILD_DIR)/tooldir' \
	--without-freetype --without-x --without-gnutls && \
    $(MAKE) -C '$(BUILD_DIR)' -j$(JOBS)  && $(MAKE) -C '$(BUILD_DIR)' install

    cd '$(BUILD_DIR)' && make test
endef

# last one before endef
#cd '$(BUILD_DIR)/dlls/kernel32/tests' && make environ.ok -j$(JOBS)
#$(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
