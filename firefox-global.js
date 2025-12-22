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

pref("extensions.update.enabled", false);

// Use LANG environment variable to choose locale
pref("intl.locale.requested", "");

// Disable default browser checking.
pref("browser.shell.checkDefaultBrowser", false);

// Disable openh264.
pref("media.gmp-gmpopenh264.enabled", false);

// Default to classic view for about:newtab
pref("browser.newtabpage.enhanced", false, sticky);

// Disable telemetry and data collection
pref("datareporting.healthreport.uploadEnabled", false);
pref("datareporting.policy.dataSubmissionEnabled", false);
pref("toolkit.telemetry.enabled", false);

// Default to no suggestions in the urlbar. This still brings a panel asking
// the user whether they want to opt-in on first use.
pref("browser.urlbar.suggest.searches", false);

// Disable HTTP2
pref("network.http.http2.enabled", false);

// Disable HTTP3
pref("network.http.http3.enable", false);

// Disable Clibboard Events
pref("dom.event.clipboardevents.enabled", false);
pref("clipboard.autocopy", false);

// Disable Accessibility
pref("accessibility.force_disabled", 1);

// Disable Service Workers
pref("dom.serviceWorkers.enabled", false);

// Disable Normandy
pref("app.normandy.enabled", false);

// Disable Autoupdate
pref("app.update.auto", false);

// Disable Beacon
pref("beacon.enabled", false);

// Disable Profile Backup
pref("browser.backup.enabled", false);

// Disable Discovery
pref("browser.discovery.enabled", false);

// Enable Download Always Ask
pref("browser.download.always_ask_before_handling_new_types", true);
pref("browser.download.panel.shown", true);
pref("browser.download.useDownloadDir", false);

// Disable http to https Auto-Fix URL Input
pref("browser.fixup.fallback-to-https", false);

// Disable Formfill
pref("browser.formfill.enable", false);

// Disable AI
pref("browser.ml.enable", false);
pref("browser.ml.chat.enabled", false);

// Disable Experimental
pref("browser.preferences.experimental", false);

// Disable Promo
pref("browser.promo.focus.enabled", false);
pref("browser.promo.pin.enabled", false);
pref("browser.vpn_promo.enabled", false);
pref("browser.preferences.moreFromMozilla", false);

// Search Settings
pref("browser.search.suggest.enabled", false);
pref("browser.search.update", false);

// Homepage Settings
pref("browser.startup.homepage.abouthome_cache.enabled", false);

// Tab Settings
pref("browser.tabs.groups.enabled", false);
pref("browser.tabs.hoverPreview.enabled", false);

// Translation Settings
pref("browser.translations.enable", false);

// Misc Settings
pref("browser.topsites.contile.enabled", false);
pref("browser.touchmode.auto", false);
pref("browser.triple_click_selects_paragraph", false);
pref("browser.uitour.enabled", false);

// URLBar Settings
pref("browser.urlbar.autoFill", false);
pref("browser.urlbar.groupLabels.enabled", false);
pref("browser.urlbar.quicksuggest.enabled", false);
pref("browser.urlbar.speculativeConnect.enabled", false);
pref("browser.urlbar.suggest.engines", false);
pref("browser.urlbar.suggest.quickactions", false);
pref("browser.browser.urlbar.suggest.recentsearches", false);
pref("browser.urlbar.suggest.remotetab", false);
pref("browser.urlbar.suggest.weather", false);
pref("browser.urlbar.trending.featureGate", false);

// Datareporting Settings
pref("datareporting.usage.uploadEnabled", false);

// Sensors Settings
pref("device.sensors.enabled", false);

// Devtools Settings
pref("devtools.accessibility.enabled", false);
pref("devtools.source-map.client-service.enabled", false);

// Battery Settings
pref("dom.battery.enabled", false);

// Network Settings
pref("network.automatic-ntlm-auth.allow-proxies", false);
pref("network.auth.sspi_detect_hash", false);
pref("network.connectivity-service.enabled", false);
pref("network.dns.disableIPv6", true);
pref("network.dns.disablePrefetch", true);
pref("network.early-hints.enabled", false);
pref("network.fetchpriority.enabled", false);

// UI Settings
pref("ui.new-webcompat-reporter.enabled", false);

// Signon Settings
pref("signon.rememberSignons", false);

// Disable WebRTC to prevent IP leak
pref("media.peerconnection.enabled", false);

// Enhanced privacy settings
pref("privacy.trackingprotection.enabled", true);
pref("privacy.trackingprotection.socialtracking.enabled", true);

// Disable geolocation
pref("geo.enabled", false);

// Disable Network Proxy
pref("network.proxy.type", 0);

// Disable Autoplay
pref("media.autoplay.default", 5);
