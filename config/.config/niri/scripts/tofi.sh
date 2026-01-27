#!/bin/bash

pkill tofi || eval "$(tofi-drun --fuzzy-match true --config ~/.config/tofi/config.conf --prompt-text '' --ascii-input true --padding-left 40% --padding-top 33%)"
