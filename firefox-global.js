// This is the Debian specific preferences file for Firefox ESR
// You can make any change in here, it is the purpose of this file.
// You can, with this file and all files present in the
// /etc/firefox-esr directory, override any preference you can see in
// about:config.
//
// It is also usable in a standard (non-esr) context. Only save file
// under /usr/lib/firefox/defaults/firefox-global.js
//
// Note that pref("name", value, locked) is allowed in these
// preferences files if you don't want users to be able to override
// some preferences.

pref("extensions.update.enabled", false, locked);

// Use LANG environment variable to choose locale
pref("intl.locale.requested", "");

// Disable default browser checking
pref("browser.shell.checkDefaultBrowser", false);

// Disable openh264
pref("media.gmp-gmpopenh264.enabled", false, locked);

// Default to classic view for about:newtab
pref("browser.newtabpage.enhanced", false, sticky);

// Disable telemetry and data collection
pref("datareporting.healthreport.uploadEnabled", false, locked);
pref("datareporting.policy.dataSubmissionEnabled", false, locked);
pref("toolkit.telemetry.enabled", false, locked);

// Default to no suggestions in the urlbar. This still brings a panel asking
// the user whether they want to opt-in on first use.
pref("browser.urlbar.suggest.searches", false, locked);

// Disable HTTP2
pref("network.http.http2.enabled", false, locked);

// Disable HTTP3
pref("network.http.http3.enable", false, locked);

// Disable captive portal service
pref("network.captive-portal-service.enabled", false, locked);

// Disable Clibboard Events
pref("dom.event.clipboardevents.enabled", false, locked);
pref("clipboard.autocopy", false, locked);

// Disable Accessibility
pref("accessibility.force_disabled", 1, locked);

// Disable Service Workers
pref("dom.serviceWorkers.enabled", false, locked);

// Disable Normandy
pref("app.normandy.enabled", false, locked);

// Disable Autoupdate
pref("app.update.auto", false, locked);

// Disable Beacon
pref("beacon.enabled", false, locked);

// Disable Profile Backup
pref("browser.backup.enabled", false, locked);

// Disable Discovery
pref("browser.discovery.enabled", false, locked);

// Enable Download Always Ask
pref("browser.download.always_ask_before_handling_new_types", true, locked);
pref("browser.download.panel.shown", true, locked);
pref("browser.download.useDownloadDir", false, locked);

// Disable http to https Auto-Fix URL Input
pref("browser.fixup.fallback-to-https", false, locked);

// Disable Formfill
pref("browser.formfill.enable", false, locked);

// Disable AI
pref("browser.ml.enable", false, locked);
pref("browser.ml.chat.enabled", false, locked);

// Disable Experimental
pref("browser.preferences.experimental", false, locked);

// Disable Promo
pref("browser.promo.focus.enabled", false, locked);
pref("browser.promo.pin.enabled", false, locked);
pref("browser.vpn_promo.enabled", false, locked);
pref("browser.preferences.moreFromMozilla", false, locked);

// Search Settings
pref("browser.search.suggest.enabled", false, locked);
pref("browser.search.update", false, locked);

// Homepage Settings
pref("browser.startup.homepage.abouthome_cache.enabled", false, locked);

// Tab Settings
pref("browser.tabs.groups.enabled", false, locked);
pref("browser.tabs.hoverPreview.enabled", false, locked);

// Translation Settings
pref("browser.translations.enable", false, locked);

// Misc Settings
pref("browser.topsites.contile.enabled", false, locked);
pref("browser.touchmode.auto", false, locked);
pref("browser.triple_click_selects_paragraph", false, locked);
pref("browser.uitour.enabled", false, locked);

// URLBar Settings
pref("browser.urlbar.autoFill", false, locked);
pref("browser.urlbar.groupLabels.enabled", false, locked);
pref("browser.urlbar.quicksuggest.enabled", false, locked);
pref("browser.urlbar.speculativeConnect.enabled", false, locked);
pref("browser.urlbar.suggest.engines", false, locked);
pref("browser.urlbar.suggest.quickactions", false, locked);
pref("browser.browser.urlbar.suggest.recentsearches", false, locked);
pref("browser.urlbar.suggest.remotetab", false, locked);
pref("browser.urlbar.suggest.weather", false, locked);
pref("browser.urlbar.trending.featureGate", false, locked);

// Datareporting Settings
pref("datareporting.usage.uploadEnabled", false, locked);

// Sensors Settings
pref("device.sensors.enabled", false, locked);

// Devtools Settings
pref("devtools.accessibility.enabled", false, locked);
pref("devtools.source-map.client-service.enabled", false, locked);

// Battery Settings
pref("dom.battery.enabled", false, locked);

// Network Settings
pref("network.automatic-ntlm-auth.allow-proxies", false, locked);
pref("network.auth.sspi_detect_hash", false, locked);
pref("network.connectivity-service.enabled", false, locked);
pref("network.dns.disableIPv6", true, locked);
pref("network.dns.disablePrefetch", true, locked);
pref("network.early-hints.enabled", false, locked);
pref("network.fetchpriority.enabled", false, locked);

// UI Settings
pref("ui.new-webcompat-reporter.enabled", false, locked);

// Signon Settings
pref("signon.rememberSignons", false, locked);

// Disable WebRTC to prevent IP leak
pref("media.peerconnection.enabled", false, locked);

// Disable WASM (web assembly)
pref("javascript.options.wasm", false, locked);
pref("devtools.debugger.features.wasm", false, locked);

// Enhanced privacy settings
pref("privacy.trackingprotection.enabled", true, locked);
pref("privacy.trackingprotection.socialtracking.enabled", true, locked);

// Disable geolocation
pref("geo.enabled", false, locked);

// Disable Network Proxy
pref("network.proxy.type", 0, locked);

// Disable Autoplay
pref("media.autoplay.default", 5, locked);

// Disable setting remote preferences
pref("remote.prefs.recommended", false, locked);
