import bpy
import json
output=dict()

    
def transformToCode(name):
    filepath = bpy.path.abspath("//")
    f = open(f"{filepath}/{name}.txt", "w")
    objects = bpy.data.objects
    names = [i.name for i in objects]
    if name not in names:
        f.write("Объект с таким именем не найден")
        return
    obj = objects[name]
    vertices = [vertex.co for vertex in  obj.data.vertices.values()]
    polygons = [[vertex for vertex in polygon.vertices] for polygon in obj.data.polygons]
    
    output['verteces'] = str(vertices)
    output['polygons'] = str(polygons)
    f.write(json.dumps(output))
    f.close()
    
    
transformToCode("Cube")

