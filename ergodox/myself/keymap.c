#include QMK_KEYBOARD_H
#include "version.h"

#define BASE 0 // default layer
#define SYMB 1 // symbols
#define MDIA 2 // media keys

enum custom_keycodes {
#ifdef ORYX_CONFIGURATOR
  EPRM = EZ_SAFE_RANGE,
#else
  EPRM = SAFE_RANGE,
#endif
  VRSN,
  RGB_SLD
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
/* Keymap 0: Basic layer
 *
 * ,--------------------------------------------------.           ,--------------------------------------------------.
 * |   `    |   1  |   2  |   3  |   4  |   5  | Esc  |           |  =   |   6  |   7  |   8  |   9  |   0  |   -    |
 * |--------+------+------+------+------+------+------|           |------+------+------+------+------+------+--------|
 * | Tab    |   Q  |   W  |   E  |   R  |   T  |  (   |           |  )   |   Y  |   U  |   I  |   O  |   P  |   \    |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * | Ctrl   | A/L2 |   S  |   D  |   F  |   G  |------|           |------|   H  |   J  |   K  |   L  | ;/L2 | '/L1   |
 * |--------+------+------+------+------+------|  [ / |           |  ] / |------+------+------+------+------+--------|
 * | LShift | Z/L1 |   X  |   C  |   V  |   B  | Hyper|           | Hyper|   N  |   M  |   ,  |   .  |//Ctrl| RShift |
 * `--------+------+------+------+------+-------------'           `-------------+------+------+------+------+--------'
 *   |Cmd+x |Cmd+v |Cmd+c | Alt  | Cmd  |                                       | Cmd  | Left | Down |  Up  |Right |
 *   `----------------------------------'                                       `----------------------------------'
 *                                        ,-------------.       ,-------------.
 *                                        | Hyper|  BS  |       | Del  | Esc  |
 *                                 ,------|------|------|       |------+--------+------.
 *                                 |      |      | L2   |       | L1   |        |      |
 *                                 |Space |LShift|------|       |------| RShift |Enter |
 *                                 |      |      |Cmd+Sp|       | MO(1)|        |      |
 *                                 `--------------------'       `----------------------'
 */
// If it accepts an argument (i.e, is a function), it doesn't need KC_.
// Otherwise, it needs KC_*
[BASE] = LAYOUT_ergodox(
        // left hand
        KC_GRV,     KC_1,           KC_2,         KC_3,    KC_4,    KC_5,    KC_ESC,
        KC_TAB,     KC_Q,           KC_W,         KC_E,    KC_R,    KC_T,    KC_LPRN,
        KC_LCTL,    LT(MDIA, KC_A), KC_S,         KC_D,    KC_F,    KC_G,
        KC_LSFT,    LT(SYMB, KC_Z), KC_X,         KC_C,    KC_V,    KC_B,    ALL_T(KC_LBRC),
        LGUI(KC_X), LGUI(KC_V),     LGUI(KC_C),   KC_LALT, KC_LGUI,
                                                            ALL_T(KC_NO),          KC_BSPC,
                                                                                   TG(MDIA),
                                                            KC_SPC,       KC_LSFT, LGUI(KC_SPC),
        // right hand
             KC_EQL,         KC_6, KC_7,    KC_8,    KC_9,    KC_0,              KC_MINS,
             KC_RPRN,        KC_Y, KC_U,    KC_I,    KC_O,    KC_P,              KC_BSLS,
                             KC_H, KC_J,    KC_K,    KC_L,    LT(MDIA, KC_SCLN), LT(SYMB, KC_QUOT),
             ALL_T(KC_RBRC), KC_N, KC_M,    KC_COMM, KC_DOT,  CTL_T(KC_SLSH),    KC_RSFT,
                                   KC_LGUI, KC_LEFT, KC_DOWN, KC_UP,             KC_RIGHT,
             KC_DELT, KC_ESC,
             TG(SYMB),
             MO(SYMB), KC_RSFT,KC_ENT
    ),
/* Keymap 1: Symbol Layer
 *
 * ,--------------------------------------------------.           ,--------------------------------------------------.
 * |Version |  F1  |  F2  |  F3  |  F4  |  F5  |      |           |      |  F6  |  F7  |  F8  |  F9  |  F10 |   F11  |
 * |--------+------+------+------+------+-------------|           |------+------+------+------+------+------+--------|
 * |        |      |      |  Up  |      |      |  (   |           | Home | PgUp |   7  |   8  |   9  |   *  |   F12  |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |      | Left | Down | Right| Esc  |------|           |------| PgDn |   4  |   5  |   6  |   +  |        |
 * |--------+------+------+------+------+------|  {   |           | End  |------+------+------+------+------+--------|
 * |        |      | PgUp |      | PgDn | Ent  |      |           |      | Del  |   1  |   2  |   3  |   \  |        |
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
[SYMB] = LAYOUT_ergodox(
       // left hand
       M(0),   KC_F1,  KC_F2,  KC_F3,  KC_F4,   KC_F5,  KC_TRNS,
       KC_TRNS,KC_TRNS,KC_TRNS,KC_UP,  KC_TRNS, KC_TRNS,KC_LBRC,
       KC_TRNS,KC_TRNS,KC_LEFT,KC_DOWN,KC_RIGHT,KC_ESC,
       KC_TRNS,KC_TRNS,KC_PGUP,KC_TRNS,KC_PGDN, KC_ENT, KC_LCBR,
       KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,KC_TRNS,
                                       KC_TRNS, KC_TRNS,
                                                KC_TRNS,
                               KC_TRNS,KC_TRNS, KC_TRNS,
       // right hand
       KC_TRNS, KC_F6,   KC_F7,  KC_F8,   KC_F9,   KC_F10,  KC_F11,
       KC_HOME, KC_PGUP, KC_7,   KC_8,    KC_9,    KC_ASTR, KC_F12,
                KC_PGDN, KC_4,   KC_5,    KC_6,    KC_PLUS, KC_TRNS,
       KC_END,  KC_DELT, KC_1,   KC_2,    KC_3,    KC_BSLS, KC_TRNS,
                         KC_TRNS,KC_DOT,  KC_0,    KC_EQL,  KC_TRNS,
       KC_TRNS, KC_TRNS,
       KC_TRNS,
       KC_TRNS, KC_TRNS, KC_TRNS
),
/* Keymap 2: Media and mouse keys
 *
 * ,--------------------------------------------------.           ,--------------------------------------------------.
 * | RESET  |      |      |      |      |      |      |           |      |      |      |      |      |      |        |
 * |--------+------+------+------+------+-------------|           |------+------+------+------+------+------+--------|
 * |        |      |      | MsUp |      |      |      |           |      |      |Cmd+<-|Ctl+Up|Cmd+->|      |        |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |      |MsLeft|MsDown|MsRght|      |------|           |------|      |Ctl+<-|C+Down|Ctl+->|      |        |
 * |--------+------+------+------+------+------|      |           |      |------+------+------+------+------+--------|
 * |        |      |      |      |      |      |      |           |      |      |      | Prev | Next |      |        |
 * `--------+------+------+------+------+-------------'           `-------------+------+------+------+------+--------'
 *   |Cmd+x |Cmd+v |Cmd+c | Lclk | Rclk |                                       |VolDn |VolUp | Mute |      |      |
 *   `----------------------------------'                                       `----------------------------------'
 *                                        ,-------------.       ,-------------.
 *                                        |      |      |       |      |      |
 *                                 ,------|------|------|       |------+------+------.
 *                                 |      |      |      |       |      |      |      |
 *                                 |      |      |------|       |------| LClk | RClk |
 *                                 |      |      |      |       |      |      |      |
 *                                 `--------------------'       `--------------------'
 */
// MEDIA AND MOUSE
[MDIA] = LAYOUT_ergodox(
       RESET,     KC_TRNS,   KC_TRNS,   KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS,   KC_TRNS,   KC_TRNS,   KC_MS_U, KC_TRNS, KC_TRNS, KC_TRNS,
       KC_TRNS,   KC_TRNS,   KC_MS_L,   KC_MS_D, KC_MS_R, KC_TRNS,
       KC_TRNS,   KC_TRNS,   KC_TRNS,   KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
       LGUI(KC_X),LGUI(KC_V),LGUI(KC_C),KC_BTN1, KC_BTN2,
                                                          KC_TRNS, KC_TRNS,
                                                                   KC_TRNS,
                                                 KC_TRNS, KC_TRNS, KC_TRNS,
    // right hand
       KC_TRNS,  KC_TRNS, KC_TRNS,       KC_TRNS,       KC_TRNS,        KC_TRNS, KC_TRNS,
       KC_TRNS,  KC_TRNS, LGUI(KC_LEFT), LCTL(KC_UP),   LGUI(KC_RIGHT), KC_TRNS, KC_TRNS,
                 KC_TRNS, LCTL(KC_LEFT), LCTL(KC_DOWN), LCTL(KC_RIGHT), KC_TRNS, KC_TRNS,
       KC_TRNS,  KC_TRNS, KC_TRNS,       KC_MPRV,       KC_MNXT,        KC_TRNS, KC_TRNS,
                          KC_VOLD,       KC_VOLU,       KC_MUTE,        KC_TRNS, KC_TRNS,
       KC_TRNS, KC_TRNS,
       KC_TRNS,
       KC_TRNS, KC_BTN1, KC_BTN2
),
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  if (record->event.pressed) {
    switch (keycode) {
      case EPRM:
        eeconfig_init();
        return false;
      case VRSN:
        SEND_STRING (QMK_KEYBOARD "/" QMK_KEYMAP " @ " QMK_VERSION);
        return false;
      #ifdef RGBLIGHT_ENABLE
      case RGB_SLD:
        rgblight_mode(1);
        return false;
      #endif
    }
  }
  return true;
}

// Runs just one time when the keyboard initializes.
void matrix_init_user(void) {
#ifdef RGBLIGHT_COLOR_LAYER_0
  rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
#endif
};

// Runs whenever there is a layer state change.
layer_state_t layer_state_set_user(layer_state_t state) {
  ergodox_board_led_off();
  ergodox_right_led_1_off();
  ergodox_right_led_2_off();
  ergodox_right_led_3_off();

  uint8_t layer = biton32(state);
  switch (layer) {
      case 0:
        #ifdef RGBLIGHT_COLOR_LAYER_0
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
        #else
        #ifdef RGBLIGHT_ENABLE
          rgblight_init();
        #endif
        #endif
        break;
      case 1:
        ergodox_right_led_1_on();
        #ifdef RGBLIGHT_COLOR_LAYER_1
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_1);
        #endif
        break;
      case 2:
        ergodox_right_led_2_on();
        #ifdef RGBLIGHT_COLOR_LAYER_2
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_2);
        #endif
        break;
      case 3:
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_3
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_3);
        #endif
        break;
      case 4:
        ergodox_right_led_1_on();
        ergodox_right_led_2_on();
        #ifdef RGBLIGHT_COLOR_LAYER_4
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_4);
        #endif
        break;
      case 5:
        ergodox_right_led_1_on();
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_5
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_5);
        #endif
        break;
      case 6:
        ergodox_right_led_2_on();
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_6
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_6);
        #endif
        break;
      case 7:
        ergodox_right_led_1_on();
        ergodox_right_led_2_on();
        ergodox_right_led_3_on();
        #ifdef RGBLIGHT_COLOR_LAYER_7
          rgblight_setrgb(RGBLIGHT_COLOR_LAYER_7);
        #endif
        break;
      default:
        break;
    }

  return state;
};
