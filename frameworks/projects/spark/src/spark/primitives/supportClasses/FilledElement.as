////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2003-2006 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.graphics
{

import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.geom.Rectangle;
import mx.events.PropertyChangeEvent;
import mx.graphics.IFill;

/**
 *  The FilledElement class is the base class for graphics elements that contain a stroke
 *  and a fill.
 *  This is a base class, and is not used directly in MXML or ActionScript.
 */
public class FilledElement extends StrokedElement
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     */
    public function FilledElement()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  fill
    //----------------------------------

    /**
     *  @private
     */
     protected var _fill:IFill;
    
    [Inspectable(category="General")]

    /**
     *  The object that defines the properties of the fill.
     *  If not defined, the object is drawn without a fill.
     * 
     *  @default null
     */
    public function get fill():IFill
    {
        return _fill;
    }
    
    /**
     *  @private
     */
    public function set fill(value:IFill):void
    {
        var fillEventDispatcher:EventDispatcher;
        
        fillEventDispatcher = _fill as EventDispatcher;
        if (fillEventDispatcher)
            fillEventDispatcher.removeEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, 
                fill_propertyChangeHandler);
            
        _fill = value;
        
        fillEventDispatcher = _fill as EventDispatcher;
        if (fillEventDispatcher)
            fillEventDispatcher.addEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, 
                fill_propertyChangeHandler);
            
        invalidateDisplayList();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @inheritDoc
     */
    override protected function beginDraw(g:Graphics):void
    {
        // Don't call super.beginDraw() since it will also set up an 
        // invisible fill.
        
        var bounds:Rectangle = new Rectangle(drawX, drawY, width, height);
        if (stroke)
            stroke.draw(g, bounds);
        else
            g.lineStyle();
        
        if (fill)
            fill.begin(g, bounds);
    }
    
    /**
     *  @inheritDoc
     */
    override protected function endDraw(g:Graphics):void
    {
        // Don't call super.endDraw() since it will clear the invisible
        // fill.
        
        if (fill)
            fill.end(g);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private function fill_propertyChangeHandler(event:Event):void
    {
        invalidateDisplayList();
    }
}
}
