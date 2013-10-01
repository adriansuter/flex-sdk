////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package spark.components.itemRenderers
{

import mx.core.BitmapAsset;
import mx.styles.IStyleClient;

import spark.utils.MultiDPIBitmapSourceExt;

/** Default lightweight  class for rendering embedded Bitmaps  or Multi-DPI Bitmaps in a MobileGrid cell .
 * <p> You define the icon to be used in each cell by setting either iconField or iconFunction properties.  </p>
 *  */
public class ItemBitmapPartRenderer extends BitmapAsset implements IItemPartRendererBase
{

    private var _iconFunction:Function = null;
    private var _iconField:String = null;
    protected var _data:Object;

    public function ItemBitmapPartRenderer()
    {
        super();
    }

    /**
     *  The name of the field or property in the DataGrid's dataProvider item that defines the icon to display for this renderer's column.
     *  <p> The fields value must be either an embedded bitmap's class, or or MultiBitmapSourceExt object.   </p>
     *   <p> If not set, then iconFunction will be used.  </p>
     *  @default null
     *
     *  @see #iconFunction
     *  @see  spark.utils.MultiDPIBitmapSourceExt
     *
     */
    public function get iconField():String
    {
        return _iconField;
    }

    public function set iconField(value:String):void
    {
        _iconField = value;
    }

    /**
     *  An user-provided function that converts a data provider item into an icon to display in each cell for this renderer's column.
     *
     *  <p>if set, this property is used even if iconField is also set.</p>
     *  <p>The function specified to the <code>iconFunction</code> property
     *  must have the following signature:</p>
     *
     *  <pre>iconFunction(item:Object):Object</pre>
     *
     *  <p>The <code>item</code> parameter is the data provider item for an entire row.</p>
     *  <p> The function must return either an embedded bitmap's class, or a MultiBitmapSourceExt object .</p>
     *
     *  @default null
     *
     *  @see #iconLabel
     *  @see  spark.utils.MultiDPIBitmapSourceExt
     *
     */
    public function get iconFunction():Function
    {
        return _iconFunction;
    }

    public function set iconFunction(value:Function):void
    {
        _iconFunction = value;
    }

    public function set data(value:Object):void
    {
        var iconClass:Class;
        _data = value;
        var iconSource:Object = _iconFunction != null ? _iconFunction(_data) : _data[_iconField];
        if (iconSource is MultiDPIBitmapSourceExt)
        {
            iconClass = MultiDPIBitmapSourceExt(iconSource).getSource(NaN) as Class;
        }
        else
        {
            iconClass = iconSource as Class;
        }
        if (iconClass != null)
        {
            var icon:BitmapAsset = new iconClass();
            this.bitmapData = icon.bitmapData;
        }
        else
        {
            this.bitmapData = null;
        }
    }

    public function get data():Object
    {
        return _data;
    }

    public function getPreferredBoundsWidth(postLayoutTransform:Boolean = true):Number
    {
        return bitmapData.width;
    }

    public function getPreferredBoundsHeight(postLayoutTransform:Boolean = true):Number
    {
        return bitmapData.height;
    }

    override public function setActualSize(newWidth:Number, newHeight:Number):void
    {
        // do nothing, bitmap renderer don't stretch for now
    }

    public function set styleProvider(value:IStyleClient):void
    {
        // do nothing, this renderer does not manages styles for now.
    }

    public function set cssStyleName(value:String):void
    {
    }

}
}