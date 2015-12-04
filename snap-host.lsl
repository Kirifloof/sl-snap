string snap_targetName = "ONAKoboldBody";
string snap_schemaURL = "https://github.com/Kirifloof/sl-snap/raw/master/schema/ONA-Kobold0.06.json";

default {
    state_entry() {
        llListen(-343460, "", NULL_KEY, "");
    }
    listen(integer channel, string name, key sender, string msg) {
        if (channel == -343460) { // SNAP message
            list tk = llParseString2List(msg, ["|"], []);
            string cmd = llList2String(tk, 0);
            
            if (cmd == "SNAP-PING") llRegionSayTo(sender, -343460, "SNAP-PONG|" + snap_targetName);
            else if (cmd == "SNAP-GET" && llList2String(tk, 1) == snap_targetName) {
                integer pin = 1 + (integer)llFrand(DEBUG_CHANNEL - 1);
                llSetRemoteScriptAccessPin(pin);
                llRegionSayTo(sender, -343460, "SNAP-APPLY|" + snap_targetName + "|" + llList2String(tk, 2) + "|" + (string)pin + "|" + snap_schemaURL);
            }
        }
    }
}