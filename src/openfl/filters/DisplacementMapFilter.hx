package openfl.filters;
#if !flash

// TODO
import lime._internal.graphics.ImageDataUtil;
// TODO
import openfl.display.BitmapDataChannel;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.ColorTransform;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)

@:final class DisplacementMapFilter extends BitmapFilter {

    @:noCompletion private static var __displacementMapShader = new DisplacementMapShader();

    public var alpha (get, set):Float;
    public var color (get, set):Int;
    public var componentX (get, set):Int;
    public var componentY (get, set):Int;
    public var mapBitmap (get, set):BitmapData;
    public var mapPoint (get, set):Point;
    public var mode (get, set):String;
    public var scaleX (get, set):Float;
    public var scaleY (get, set):Float;

    @:noCompletion private var __alpha:Float;
    @:noCompletion private var __color:Int;

    @:noCompletion private var __componentX:Int;
    @:noCompletion private var __componentY:Int;

    @:noCompletion private var __mapBitmap:BitmapData;
    @:noCompletion private var __mapPoint:Point;

    @:noCompletion private var __mode:String;

    @:noCompletion private var __scaleX:Float;
    @:noCompletion private var __scaleY:Float;

    private static var sOffset:Array<Float> = [0.5, 0.5, 0.0, 0.0];
    private static var sMatrixData:Array<Float> = [
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
    ];

    public function new(mapBitmap:BitmapData = null, mapPoint:Point = null, componentX:Int = 0, componentY:Int = 0, scaleX:Float = 0.0, scaleY:Float = 0.0, mode:String = 'wrap', color:Int = 0, alpha:Float = 0.0) {
        super();

        __color = color;
        __alpha = alpha;

        __componentX = componentX;
        __componentY = componentY;

        __mapBitmap = mapBitmap;
        __mapPoint = null != mapPoint ? mapPoint : new Point(0.0, 0.0);

        __mode = mode; // TODO: not used

        __scaleX = scaleX;
        __scaleY = scaleY;

        __needSecondBitmapData = false;
        __preserveObject = false;
        __renderDirty = true;

        __numShaderPasses = 1;
    }

    public override function clone():BitmapFilter {
        return new DisplacementMapFilter (
        __mapBitmap.clone(),
        __mapPoint.clone(),
        __componentX,
        __componentY,
        __scaleX,
        __scaleY,
        __mode,
        __color,
        __alpha
        );
    }

    @:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {

        ImageDataUtil.displace(bitmapData.image, sourceBitmapData.image, __mapBitmap.image, __componentX, __componentY, __scaleX, __scaleY);

        return bitmapData;

    }

    @:noCompletion private function __updateMapMatrix():Void {
        var columnX:Int, columnY:Int;
        var scale:Float = 1.0; // TODO: Stage's scale ?
        var textureWidth:Float = __mapBitmap.width;
        var textureHeight:Float = __mapBitmap.height;

        for (i in 0...16) {
            sMatrixData[i] = 0;
        }

        if (__componentX == BitmapDataChannel.RED) columnX = 0;
        else if (__componentX == BitmapDataChannel.GREEN) columnX = 1;
        else if (__componentX == BitmapDataChannel.BLUE) columnX = 2;
        else columnX = 3;

        if (__componentY == BitmapDataChannel.RED) columnY = 0;
        else if (__componentY == BitmapDataChannel.GREEN) columnY = 1;
        else if (__componentY == BitmapDataChannel.BLUE) columnY = 2;
        else columnY = 3;

        sMatrixData[columnX * 4] = __scaleX * scale / textureWidth;
        sMatrixData[columnY * 4 + 1] = __scaleY * scale / textureHeight;
    }

    @:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int):Shader {

        #if !macro

        // TODO: mapX/mapY/mapU/mapV + offsets

        __updateMapMatrix();

        __displacementMapShader.uOffsets.value = sOffset;
        __displacementMapShader.uDisplacements.value = sMatrixData;

        __displacementMapShader.mapTextureCoordsOffset.value = [
            mapPoint.x / __mapBitmap.width,
            mapPoint.y / __mapBitmap.height
        ];

        __displacementMapShader.mapTexture.input = __mapBitmap;

        #end

        return __displacementMapShader;
    }

    // Get & Set Methods

    @:noCompletion private function get_alpha():Float {
        return __alpha;
    }

    @:noCompletion private function set_alpha(value:Float):Float {
        if (value != __alpha) __renderDirty = true;
        return __alpha = value;
    }

    @:noCompletion private function get_componentX():Int {
        return __componentX;
    }

    @:noCompletion private function set_componentX(value:Int):Int {
        if (value != __componentX) __renderDirty = true;
        return __componentX = value;
    }

    @:noCompletion private function get_componentY():Int {
        return __componentY;
    }

    @:noCompletion private function set_componentY(value:Int):Int {
        if (value != __componentY) __renderDirty = true;
        return __componentY = value;
    }

    @:noCompletion private function get_color():Int {
        return __color;
    }

    @:noCompletion private function set_color(value:Int):Int {
        if (value != __color) __renderDirty = true;
        return __color = value;
    }

    @:noCompletion private function get_scaleX():Float {
        return __scaleX;
    }

    @:noCompletion private function set_scaleX(value:Float):Float {
        if (value != __scaleX) __renderDirty = true;
        return __scaleX = value;
    }

    @:noCompletion private function get_scaleY():Float {
        return __scaleY;
    }

    @:noCompletion private function set_scaleY(value:Float):Float {
        if (value != __scaleY) __renderDirty = true;
        return __scaleY = value;
    }

    @:noCompletion private function get_mapBitmap():BitmapData {
        return __mapBitmap;
    }

    @:noCompletion private function set_mapBitmap(value:BitmapData):BitmapData {
        if (value != __mapBitmap) __renderDirty = true;
        return __mapBitmap = value;
    }

    @:noCompletion private function get_mapPoint():Point {
        return __mapPoint;
    }

    @:noCompletion private function set_mapPoint(value:Point):Point {
        if (value != __mapPoint) __renderDirty = true;
        return __mapPoint = value;
    }

    @:noCompletion private function get_mode():String {
        return __mode;
    }

    @:noCompletion private function set_mode(value:String):String {
        if (value != __mode) __renderDirty = true;
        return __mode = value;
    }
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

private class DisplacementMapShader extends BitmapFilterShader {

    @:glFragmentSource(
    "
        uniform sampler2D openfl_Texture;
        uniform sampler2D mapTexture;

        uniform mat4 openfl_Matrix;

        uniform vec4 uOffsets;
        uniform mat4 uDisplacements;

        varying vec2 openfl_TextureCoordV;
        varying vec2 mapTextureCoords;

            void main(void) {
                vec4 map_color = texture2D(mapTexture, mapTextureCoords);
                vec4 map_color_mod = map_color - uOffsets;

                map_color_mod = map_color_mod * vec4(map_color.w, map_color.w, 1.0, 1.0);

                vec4 displacements_multiplied = map_color_mod * uDisplacements;
                vec4 result = vec4(openfl_TextureCoordV.x, openfl_TextureCoordV.y, 0.0, 1.0) + displacements_multiplied;

                gl_FragColor = texture2D(openfl_Texture, vec2(result));
            }
    "
    )

    @:glVertexSource(

    "
        uniform mat4 openfl_Matrix;

        uniform vec2 mapTextureCoordsOffset;

        attribute vec4 openfl_Position;
        attribute vec2 openfl_TextureCoord;

        varying vec2 openfl_TextureCoordV;

        varying vec2 mapTextureCoords;

        void main(void) {
            gl_Position = openfl_Matrix * openfl_Position;

            openfl_TextureCoordV = openfl_TextureCoord;
            mapTextureCoords = openfl_TextureCoord - mapTextureCoordsOffset;
        }
    "
    )

    public function new() {
        super();
    }

}

#else
typedef DisplacementMapFilter = flash.filters.DisplacementMapFilter;
#end