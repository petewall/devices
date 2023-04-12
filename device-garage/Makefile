SHELL := /bin/bash

.PHONY: build clean set-pipeline upload 

clean:
	rm -rf .esphome device.yaml firmware.bin secrets.yaml

secrets.yaml: ../secrets-template.yaml
	ytt \
		--file ../secrets-template.yaml \
		--data-value-file wifi.ssid=<(op read "op://Private/Home WiFi/network name") \
		--data-value-file wifi.password=<(op read "op://Private/Home WiFi/wireless network password") \
		> secrets.yaml

device.yaml: data.yaml secrets.yaml ../template.yaml button-overlay.yaml ../lib/i2c-overlay.yaml ../lib/sht30-overlay.yaml version
	ytt \
		--file ../template.yaml \
		--file button-overlay.yaml \
		--file ../lib/i2c-overlay.yaml \
		--file ../lib/sht30-overlay.yaml \
		--data-values-file secrets.yaml \
		--data-values-file <(ytt -f data.yaml --data-value-file version=version) \
		> device.yaml

firmware.bin: device.yaml
	esphome device.yaml compile
	cp .esphome/build/garage_$(shell sed -e "s/\./_/g" version)/.pioenvs/garage_$(shell sed -e "s/\./_/g" version)/firmware.bin firmware.bin

build: firmware.bin

upload: firmware.bin
	esphome device.yaml upload
