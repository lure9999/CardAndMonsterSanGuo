#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D CC_Texture0;

uniform vec3 IconParm;

void main() {

	vec2 IconSize = vec2(IconParm.x , IconParm.y );
	
	float fgray = IconParm.z;
	
	vec2 CenterPos = vec2(0.5 , 0.5 );
	
	float Radius = 0.0;
	
	if(IconSize.x > IconSize.y)
	{
		Radius = IconSize.y*0.5;
	}
	else
	{
		Radius = IconSize.x*0.5;
	}	
	
	vec2 DIS = (v_texCoord - CenterPos)*IconSize;
	
	if (length(DIS) <= Radius)	
	{
		if (fgray > 0.1)
		{
			float alpha = texture2D(CC_Texture0, v_texCoord).a;
			
			float grey = dot(texture2D(CC_Texture0, v_texCoord).rgb, vec3(0.299, 0.587, 0.114));
			
			gl_FragColor = vec4(grey, grey, grey, alpha);
		}
		else
		{
			gl_FragColor = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
		}
	}
	else
	{
		gl_FragColor = vec4(0 , 0 , 0 , 0);
	}
}

