shader_type canvas_item;

// Степень пикселизации (размер "блока" в пикселях)
uniform float pixel_size : hint_range(1, 100) = 4.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;


void fragment() {
	// 1. Получаем размер исходной текстуры в пикселях
	vec2 size = vec2(textureSize(SCREEN_TEXTURE, 0));
	
	// 2. Рассчитываем новые UV-координаты. 
	// Мы делим UV на коэффициент, округляем и умножаем обратно.
	// Это создает эффект "ступенчатости".
	vec2 pixel_uv = floor(SCREEN_UV * size / pixel_size) * pixel_size / size;
	
	// 3. Берем цвет из текстуры по новым координатам
	COLOR = texture(SCREEN_TEXTURE, pixel_uv);
}

