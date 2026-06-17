from PIL import Image, ImageFilter

def remove_white_background(input_path, output_path, threshold=220):
    img = Image.open(input_path).convert('RGBA')
    datas = img.getdata()
    
    newData = []
    for item in datas:
        avg = (item[0] + item[1] + item[2]) / 3
        if avg > threshold:
            alpha = max(0, int((255 - avg) * 3))
            newData.append((item[0], item[1], item[2], alpha))
        else:
            newData.append(item)
    
    img.putdata(newData)
    img = img.filter(ImageFilter.SMOOTH)
    img.save(output_path, 'PNG')
    print(f'Saved: {output_path}')

remove_white_background('itogcat.jpg', 'itogcat.png', threshold=200)
remove_white_background('itogdog.jpg', 'itogdog.png', threshold=200)

print('Done! White backgrounds and edges cleaned.')
