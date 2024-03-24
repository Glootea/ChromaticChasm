import bpy, bmesh, itertools, json, os, lzstring
from bpy import context

output = dict()


def main():
    createAlphabet("0", "5")


def verticesToCoordinateList(vertex):
    return [round(vertex.co[0], 2), round(vertex.co[1], 2), round(vertex.co[2], 2)]


def getOutputString(objName):
    return (
        "'"
        + objName
        + "'"
        + " : '"
        + lzstring.LZString().compressToBase64(json.dumps(output))
        + "',"
    )


def writeToFile(fileName, output):
    filepath = bpy.path.abspath("//") + "/models"
    if not os.path.exists(filepath):
        os.makedirs(filepath)
    f = open(f"{filepath}/{str(fileName)}.txt", "w")
    f.write(output)
    f.close()


def transformPlanesToCode(name, pivotType):

    objects = bpy.data.objects
    # names = [i.name for i in objects]
    #    # if name not in names:
    #    #     f.write("Объект с таким именем не найден")
    #    #     return
    obj = objects[name]
    vertices = [
        verticesToCoordinateList(vertex) for vertex in obj.data.vertices.values()
    ]
    edges = [[vertex for vertex in polygon.vertices] for polygon in obj.data.polygons]
    output["type"] = "Drawable3D"
    output["vertices"] = vertices
    output["edges"] = edges
    # writeToFile(
    #     name,
    #     fillFileTemplate(obj.name, getOutputString(vertices, edges), "Positionable"),
    # )
    writeToFile(name, getOutputString(name))


def transformEdgesToCode(name):
    # filepath = bpy.path.abspath("//") + "/models"
    # if not os.path.exists(filepath):
    #     os.makedirs(filepath)
    # f = open(f"{filepath}/{name}.txt", "w")
    objects = bpy.data.objects
    # names = [i.name for i in objects]
    # if name not in names:
    #     f.write("Объект с таким именем не найден")
    #     return
    obj = objects[name]
    vertices = [
        verticesToCoordinateList(vertex) for vertex in obj.data.vertices.values()
    ]
    polygons = [vertex for polygon in obj.data.edges for vertex in polygon.vertices]
    normals = [polygon.normal for polygon in obj.data.polygons]
    output["type"] = "Drawable2D"
    output["vertices"] = vertices
    output["edges"] = polygons
    writeToFile(name, getOutputString(name))
    # f.write(getOutputString(name))
    # f.close()


def createAlphabet(startChar, endChat):
    view_layer = bpy.context.view_layer
    for c in list(map(chr, range(ord(startChar), ord(endChat) + 1))):
        myFontCurve = bpy.data.curves.new(type="FONT", name=c)
        textObj = bpy.data.objects.new(c, myFontCurve)
        textObj.location.x += ord(c) - ord(startChar)
        textObj.data.body = c
        fnt = bpy.data.fonts.load(
            "C:\\Programming\\Project\\Flutter\\chromatic_chasm\\blender\\Chicago_Regular.ttf"
        )
        textObj.data.font = fnt
        bpy.context.collection.objects.link(textObj)
        if textObj.name not in view_layer.active_layer_collection.collection.objects:
            view_layer.active_layer_collection.collection.objects.link(textObj)
        textObj.select_set(True)
        view_layer.objects.active = textObj
        cleanMesh(textObj)
        # context.view_layer.objects.active = context.scene.objects.get(textObj.name)
        cleanAndExtrude(textObj, 0.05)
        transformEdgesToCode(textObj.name)


def cleanMesh(obj):
    if obj and obj.type in {"MESH", "CURVE", "FONT"}:
        bpy.ops.object.convert(target="MESH")
        bpy.ops.object.mode_set(mode="EDIT")
        bpy.ops.mesh.select_mode(use_extend=False, use_expand=False, type="FACE")
        bpy.ops.mesh.select_all(action="SELECT")
        bpy.ops.mesh.dissolve_limited()
        bpy.ops.mesh.intersect_boolean(
            operation="UNION", use_swap=False, use_self=True, solver="EXACT"
        )
        bpy.ops.mesh.select_all(action="SELECT")
        bpy.ops.mesh.dissolve_limited()
        bpy.ops.mesh.select_all(action="SELECT")
        bpy.ops.mesh.dissolve_limited()
        bpy.ops.mesh.select_all(action="DESELECT")


def cleanAndExtrude(obj, depth):
    object = bpy.context.active_object
    bm = bmesh.from_edit_mesh(object.data)
    uselessVertices = [v for v in bm.verts if len(v.link_edges) == 3]
    bpy.ops.object.mode_set(mode="EDIT")
    for i in itertools.permutations(uselessVertices, 2):
        try:
            i[0].select_set(True)
            i[1].select_set(True)
            bpy.ops.mesh.select_mode(use_extend=False, use_expand=False, type="VERT")
            bpy.ops.mesh.select_mode(
                use_extend=False, use_expand=False, type="EDGE"
            )  # needed because first to two vertices does not define edge somehow
            bpy.ops.mesh.delete(type="EDGE")
        except:  # to avoid deleting vertices that are not connected by edge
            a = 0
    bpy.ops.object.mode_set(mode="EDIT")
    bpy.ops.mesh.select_all(action="SELECT")
    bpy.ops.mesh.extrude_edges_move(
        TRANSFORM_OT_translate={"value": (0.0, 0.0, depth)}
    )  # add 3d depth
    decimate = object.modifiers.new(name="Decimate", type="DECIMATE")
    decimate.decimate_type = "DISSOLVE"
    decimate.angle_limit = 0.436332  # 25 degrees
    bpy.ops.object.mode_set(mode="OBJECT")
    bpy.ops.object.modifier_apply(modifier="Decimate")
    bpy.context.active_object.select_set(False)


if __name__ == "__main__":
    main()
