/* Copyright 2019 Biacco42
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include QMK_KEYBOARD_H
#define LCG_T(kc)  MT(MOD_LCTL | MOD_LGUI, kc)  // Mod tap: kc when tapped, CTL+GUI when held.

enum meishi2_layers {
    _BASE,
    _LOWER,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [_BASE] = LAYOUT( /* Base */
/*    HYPR(KC_M), KC_LANG1, KC_LANG2, LT(_LOWER,KC_MPLY) \ */
    HYPR(KC_M), HYPR(KC_M), LCG_T(KC_F), LT(_LOWER,KC_LANG2) \
  ),
  [_LOWER] = LAYOUT( /* Base */
    KC_TRNS, KC_VOLD, KC_VOLU, KC_TRNS \
  ),
};

void matrix_init_user(void) {

}

void matrix_scan_user(void) {

}

void led_set_user(uint8_t usb_led) {

}

