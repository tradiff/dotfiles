// Dim screen by 50%
//
// To enable:
// hyprshade on 50p
// To disable:
// hyprshade off

precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    vec3 dimmedColor = pixColor.rgb * 0.5;

    gl_FragColor = vec4(dimmedColor, pixColor.a);
}
