

#ifdef GL_ES
precision lowp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D CC_Texture0;

void main(void)
{
	//gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
	
	float alpha = texture2D(CC_Texture0, v_texCoord).a;
	float grey = dot(texture2D(CC_Texture0, v_texCoord).rgb, vec3(0.299, 0.587, 0.114));
	gl_FragColor = vec4(grey, grey, grey, alpha);
}