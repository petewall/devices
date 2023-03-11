SHELL := /bin/bash

.PHONY: build clean upload 

clean:
	rm -rf .esphome device.yaml firmware.bin

device.yaml: device-template.yaml version
	ytt \
		--file device-template.yaml \
		--data-value-file wifi.ssid=<(op read "op://Private/Home WiFi/network name") \
		--data-value-file wifi.password=<(op read "op://Private/Home WiFi/wireless network password") \
		--data-value-file version=version \
		> device.yaml

firmware.bin: device.yaml
	esphome compile device.yaml
	cp .esphome/build/base_$(shell sed -e "s/\./-/g" version)/.pioenvs/base_$(shell sed -e "s/\./-/g" version)/firmware.bin firmware.bin

build: firmware.bin

upload: firmware.bin
	esphome upload device.yaml

