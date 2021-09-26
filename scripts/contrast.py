# function luminance(r, g, b) {
#     var a = [r, g, b].map(function (v) {
#         v /= 255;
#         return v <= 0.03928
#             ? v / 12.92
#             : Math.pow( (v + 0.055) / 1.055, 2.4 );
#     });
#     return a[0] * 0.2126 + a[1] * 0.7152 + a[2] * 0.0722;
# }
# function contrast(rgb1, rgb2) {
#     var lum1 = luminance(rgb1[0], rgb1[1], rgb1[2]);
#     var lum2 = luminance(rgb2[0], rgb2[1], rgb2[2]);
#     var brightest = Math.max(lum1, lum2);
#     var darkest = Math.min(lum1, lum2);
#     return (brightest + 0.05)
#          / (darkest + 0.05);
# }

def hex_to_rgb(hex_value):
    hex_value = hex_value.lstrip('#')
    return tuple(int(hex_value[i:i+2], 16) for i in (0, 2, 4))

def luminance(r, g, b):
    def mix_value(v):
        v /= 255
        return v / 12.92 if v <= 0.03928 else pow((v + 0.055) / 1.055, 2.4)
    mix = list(map(mix_value, [r, g, b]))
    return mix[0] * 0.2126 + mix[1] * 0.7152 + mix[2] * 0.0722

def contrast(rgb_int_tuple_1, rgb_int_tuple_2):
    lum1 = luminance(rgb_int_tuple_1[0], rgb_int_tuple_1[1], rgb_int_tuple_1[2])
    lum2 = luminance(rgb_int_tuple_2[0], rgb_int_tuple_2[1], rgb_int_tuple_2[2])
    brightest = max(lum1, lum2)
    darkest = min(lum1, lum2)
    return (brightest + 0.05) / (darkest + 0.05)

def wcag_normal_test(contrast):
    if abs(contrast) >= 7:
        return "AAA"
    if abs(contrast) >= 4.5:
        return "AA"
    return "Fail"

def wcag_large_test(contrast):
    if abs(contrast) >= 4.5:
        return "AAA"
    if abs(contrast) >= 3:
        return "AA"
    return "Fail"

def assess_colors(hex1, hex2):
    rgb1 = hex_to_rgb(hex1)
    rgb2 = hex_to_rgb(hex2)
    lum1 = luminance(rgb1[0], rgb1[1], rgb1[2])
    lum2 = luminance(rgb2[0], rgb2[1], rgb2[2])
    lum1_brighter = "- Brightest" if lum1 > lum2 else ""
    lum2_brighter = "- Brightest" if lum1 < lum2 else ""
    c = contrast(rgb1, rgb2)

    print(f"Color 1 : {hex1} {rgb1}{lum1_brighter}")
    print(f"Color 2 : {hex2} {rgb2}{lum2_brighter}")
    print(f"Relative contrast : {c} - WCAG normal text: {wcag_normal_test(c)} - WCAG large text: {wcag_large_test(c)}")
    print(f"\x1b[38;2;{rgb1[0]};{rgb1[1]};{rgb1[2]}m \x1b[48;2;{rgb2[0]};{rgb2[1]};{rgb2[2]}mTHIS IS A TEST MESSAGE - this is a test message 0123456789")

assess_colors("#E5C07B", "#D19A66")