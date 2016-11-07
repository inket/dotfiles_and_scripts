#!/usr/bin/env ruby

# List connected Bluetooth devices, for use with GeekTool.
# Ain't nobody got time to click the bluetooth icon.
require "yaml"

output = `system_profiler -detailLevel basic SPBluetoothDataType`
devices = YAML.load_stream(output).first["Bluetooth"]["Devices (Paired, Configured, etc.)"]
devices.keep_if { |name, properties| properties["Connected"] }

puts devices.keys.map(&:upcase).join(" + ")
