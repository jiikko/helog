.PHONY: clean
clean:
	rm -rf logs/* && rm -rf app_log

.PHONY: clean_for_bin
clean_for_bin:
	rm -rf output
