#include "ergodox.h"
#include "debug.h"
#include "action_layer.h"
#include "version.h"

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
/* Keymap 0: Basic layer
 *
 * ,--------------------------------------------------.           ,--------------------------------------------------.
 * |   `    |   1  |   2  |   3  |   4  |   5  | Esc  |           | Del  |   6  |   7  |   8  |   9  |   0  |  BS    |
 * |--------+------+------+------+------+------+------|           |------+------+------+------+------+------+--------|
 * | Tab    |   Q  |   W  |   E  |   R  |   T  |  (   |           |   )  |   Y  |   U  |   I  |   O  |   P  |   \    |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * | Ctrl   |   A  |   S  |   D  |   F  |   G  |------|           |------|   H  |   J  |   K  |   L  |; / L2| Enter  |
 * |--------+------+------+------+------+------|  [   |           |   ]  |------+------+------+------+------+--------|
 * | LShift |Z/Ctrl|   X  |   C  |   V  |   B  |      |           |      |   N  |   M  |   ,  |   .  |//Ctrl|  L1    |
 * `--------+------+------+------+------+-------------'           `-------------+------+------+------+------+--------'
 *   |      |  `   |   \  |   '  | Cmd  |                                       | LAlt |   -  |   =  |      |  PS  |
 *   `----------------------------------'                                       `----------------------------------'
 *                                        ,-------------.       ,-------------.
 *                                        | Alt  |      |       |      |Ctrl/Esc|
 *                                 ,------|------|------|       |------+--------+------.
 *                                 |      |      | L2   |       | L1   |        |      |
 *                                 |LShift| Ctrl |------|       |------|  MO(1) |RShift|
 *                                 |      |      |Ctl/Sp|       | Space|        |      |
 *                                 `--------------------'       `----------------------'
 */
// If it accepts an argument (i.e, is a function), it doesn't need KC_.
// Otherwise, it needs KC_*
[0] = KEYMAP(  // layer 0 : default
        // left hand
        KC_ESCAPE, KC_1,     KC_2,      KC_3,      KC_4,    KC_5, KC_GRAVE,
        KC_TAB,    KC_Q,     KC_W,      KC_E,      KC_R,    KC_T, KC_LPRN,
        KC_LCTL,   KC_A,     KC_S,      KC_D,      KC_F,    KC_G,
        TG(2),     KC_Z,     KC_X,      KC_C,      KC_V,    KC_B, KC_LBRACKET,
        KC_TRNS,   KC_GRAVE, KC_BSLASH, KC_QUOTE,  KC_LGUI,
                                             KC_LALT,   KC_TRNS,
                                                                 TG(2),
                                             KC_LSHIFT, KC_LCTL, LCTL(KC_SPACE),

        // right hand
             KC_DELETE,   KC_6,    KC_7,     KC_8,     KC_9,    KC_0,            KC_BSPACE,
             KC_RPRN,     KC_Y,    KC_U,     KC_I,     KC_O,    KC_P,            KC_BSLASH,
                          KC_H,    KC_J,     KC_K,     KC_L,    KC_SCOLON,       KC_ENTER,
             KC_RBRACKET, KC_N,    KC_M,     KC_COMMA, KC_DOT,  CTL_T(KC_SLASH), TG(1),
                          KC_RALT, KC_MINUS, KC_EQUAL, KC_TRNS, KC_PSCREEN,
             KC_TRNS,     KC_TRNS,
             TG(1),
             KC_SPACE,    MO(1),   KC_RSHIFT
        ),

[1] = KEYMAP(
        KC_ESCAPE,KC_F1,KC_F2,KC_F3,KC_F4,KC_F5,KC_TRNS,
        KC_TAB,KC_GRAVE,KC_HOME,KC_UP,KC_END,KC_TAB,KC_LPRN,
        KC_TRNS,KC_PIPE,KC_LEFT,KC_NO,KC_RIGHT,KC_ESCAPE,
        KC_TRNS,KC_BSLASH,KC_PGUP,KC_DOWN,KC_PGDOWN,KC_ENTER,KC_LCBR,
        KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_LGUI,
        KC_TRNS,KC_TRNS,
                KC_TRNS,
        KC_LSHIFT,KC_LCTL,LCTL(KC_SPACE),

        KC_TRNS,KC_F6,KC_F7,KC_F8,KC_F9,KC_F10,KC_F11,
        KC_RPRN,KC_DELETE,KC_7,KC_8,KC_9,KC_TILD,KC_F12,KC_BSPACE,KC_4,KC_5,KC_6,KC_QUOTE,KC_TRNS,KC_RCBR,KC_ENTER,KC_1,KC_2,KC_3,LSFT(KC_QUOTE),KC_TRNS,KC_DOT,KC_0,KC_EQUAL,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_SPACE,KC_TRNS,KC_LSHIFT
        ),

[2] = KEYMAP(
        KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TAB,KC_NO,KC_NO,KC_NO,KC_NO,KC_NO,KC_NO,KC_LCTL,KC_NO,KC_MS_ACCEL2,KC_MS_ACCEL1,KC_MS_ACCEL0,KC_NO,KC_TRNS,KC_NO,KC_NO,KC_MS_WH_DOWN,KC_MS_WH_DOWN,KC_NO,KC_NO,KC_TRNS,KC_NO,KC_NO,KC_NO,KC_LGUI,KC_TRNS,KC_TRNS,KC_TRNS,KC_LSHIFT,KC_LCTL,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_NO,KC_NO,KC_MS_WH_LEFT,KC_MS_UP,KC_MS_WH_RIGHT,KC_NO,KC_TRNS,KC_NO,KC_MS_LEFT,KC_MS_DOWN,KC_MS_RIGHT,KC_NO,KC_TRNS,KC_NO,KC_NO,KC_MS_WH_DOWN,KC_MS_DOWN,KC_MS_WH_UP,KC_NO,KC_TRNS,KC_LALT,KC_NO,KC_NO,KC_NO,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_MS_BTN1,KC_MS_BTN2
        ),

};

/* Keymap 1: Symbol Layer
 *
 * ,--------------------------------------------------.           ,--------------------------------------------------.
 * |Version |  F1  |  F2  |  F3  |  F4  |  F5  |      |           |      |  F6  |  F7  |  F8  |  F9  |  F10 |   F11  |
 * |--------+------+------+------+------+-------------|           |------+------+------+------+------+------+--------|
 * |        |   !  |   @  |   {  |   }  |   |  |      |           |      |   Up |   7  |   8  |   9  |   *  |   F12  |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |   #  |   $  |   (  |   )  |   `  |------|           |------| Down |   4  |   5  |   6  |   +  |        |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |   %  |   ^  |   [  |   ]  |   ~  |      |           |      |   &  |   1  |   2  |   3  |   \  |        |
 * `--------+------+------+------+------+-------------'           `-------------+------+------+------+------+--------'
 *   |      |      |      |      |      |                                       |      |    . |   0  |   =  |      |
 *   `----------------------------------'                                       `----------------------------------'
 *                                        ,-------------.       ,-------------.
 *                                        |      |      |       |      |      |
 *                                 ,------|------|------|       |------+------+------.
 *                                 |      |      |      |       |      |      |      |
 *                                 |      |      |------|       |------|      |      |
 *                                 |      |      |      |       |      |      |      |
 *                                 `--------------------'       `--------------------'
 */
// SYMBOLS
/*
[SYMB] = KEYMAP(
       // left hand
       M(0),   KC_F1,  KC_F2,  KC_F3,  KC_F4,  KC_F5,  KC_TRNS,
       KC_TRNS,KC_EXLM,KC_AT,  KC_LCBR,KC_RCBR,KC_PIPE,KC_TRNS,
       KC_TRNS,KC_HASH,KC_DLR, KC_LPRN,KC_RPRN,KC_GRV,
       KC_TRNS,KC_PERC,KC_CIRC,KC_LBRC,KC_RBRC,KC_TILD,KC_TRNS,
       KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,
                                       KC_TRNS,KC_TRNS,
                                               KC_TRNS,
                               KC_TRNS,KC_TRNS,KC_TRNS,
       // right hand
       KC_TRNS, KC_F6,   KC_F7,  KC_F8,   KC_F9,   KC_F10,  KC_F11,
       KC_TRNS, KC_UP,   KC_7,   KC_8,    KC_9,    KC_ASTR, KC_F12,
                KC_DOWN, KC_4,   KC_5,    KC_6,    KC_PLUS, KC_TRNS,
       KC_TRNS, KC_AMPR, KC_1,   KC_2,    KC_3,    KC_BSLS, KC_TRNS,
                         KC_TRNS,KC_DOT,  KC_0,    KC_EQL,  KC_TRNS,
       KC_TRNS, KC_TRNS,
       KC_TRNS,
       KC_TRNS, KC_TRNS, KC_TRNS
),
*/
/* Keymap 2: Media and mouse keys
 *
 * ,--------------------------------------------------.           ,--------------------------------------------------.
 * |        |      |      |      |      |      |      |           |      |      |      |      |      |      |        |
 * |--------+------+------+------+------+-------------|           |------+------+------+------+------+------+--------|
 * |        |      |      | MsUp |      |      |      |           |      |      |      |      |      |      |        |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |      |MsLeft|MsDown|MsRght|      |------|           |------| Left | Down |  Up  | Right|      |  Play  |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |      |      |      |      |      |      |           |      |      |      | Prev | Next |      |        |
 * `--------+------+------+------+------+-------------'           `-------------+------+------+------+------+--------'
 *   |RESET |      |      | Lclk | Rclk |                                       |VolUp |VolDn | Mute |      |      |
 *   `----------------------------------'                                       `----------------------------------'
 *                                        ,-------------.       ,-------------.
 *                                        |      |      |       |      |      |
 *                                 ,------|------|------|       |------+------+------.
 *                                 |      |      |      |       |      |      |Brwser|
 *                                 |      |      |------|       |------|      |Back  |
 *                                 |      |      |      |       |      |      |      |
 *                                 `--------------------'       `--------------------'
 */
// MEDIA AND MOUSE
/*
[MDIA] = KEYMAP(
       KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS, KC_TRNS, KC_TRNS, KC_MS_U, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS, KC_TRNS, KC_MS_L, KC_MS_D, KC_MS_R, KC_TRNS,
       KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
       RESET,   KC_TRNS, KC_TRNS, KC_BTN1, KC_BTN2,
                                           KC_TRNS, KC_TRNS,
                                                    KC_TRNS,
                                  KC_TRNS, KC_TRNS, KC_TRNS,
    // right hand
       KC_TRNS,  KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS,  KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
                 KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_MPLY,
       KC_TRNS,  KC_TRNS, KC_TRNS, KC_MPRV, KC_MNXT, KC_TRNS, KC_TRNS,
                          KC_VOLU, KC_VOLD, KC_MUTE, KC_TRNS, KC_TRNS,
       KC_TRNS, KC_TRNS,
       KC_TRNS,
       KC_TRNS, KC_TRNS, KC_WBAK
),
};
*/

const uint16_t PROGMEM fn_actions[] = {
    [1] = ACTION_LAYER_TAP_TOGGLE(SYMB)                // FN1 - Momentary Layer 1 (Symbols)
};

const macro_t *action_get_macro(keyrecord_t *record, uint8_t id, uint8_t opt)
{
  // MACRODOWN only works in this function
      switch(id) {
        case 0:
        if (record->event.pressed) {
          SEND_STRING (QMK_KEYBOARD "/" QMK_KEYMAP " @ " QMK_VERSION);
        }
        break;
      }
    return MACRO_NONE;
};

// Runs just one time when the keyboard initializes.
void matrix_init_user(void) {

};

// Runs constantly in the background, in a loop.
void matrix_scan_user(void) {

    uint8_t layer = biton32(layer_state);

    ergodox_board_led_off();
    ergodox_right_led_1_off();
    ergodox_right_led_2_off();
    ergodox_right_led_3_off();
    switch (layer) {
      // TODO: Make this relevant to the ErgoDox EZ.
        case 1:
            ergodox_right_led_1_on();
            break;
        case 2:
            ergodox_right_led_2_on();
            break;
        default:
            // none
            break;
    }

};
