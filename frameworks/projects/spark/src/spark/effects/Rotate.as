////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2009 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package spark.effects
{
import mx.effects.IEffectInstance;

import spark.effects.supportClasses.AnimateTransformInstance;
    
/**
 *  The Rotate effect rotates a target object
 *  in the x, y plane around the transform center. 
 *
 *  <p>If you specify any two of the angle values (angleFrom, angleTo,
 *  or angleBy), Flex calculates the third.
 *  If you specify all three, Flex ignores the <code>angleBy</code> value.</p>
 * 
 *  <p>Like all AnimateTransform-based effects, this effect will only work on subclasses
 *  of UIComponent and GraphicElement, as these effects depend on specific
 *  transform functions in those classes. </p>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Rotate&gt;</code> tag
 *  inherits all of the tag attributes of its of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:Rotate
 *    id="ID"
 *    angleBy="val"
 *    angleFrom="val"
 *    angleTo="val"
 *   /&gt;
 *  </pre>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */   
public class Rotate extends AnimateTransform
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param target The Object to animate with this effect.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function Rotate(target:Object=null)
    {
        super(target);
        instanceClass = AnimateTransformInstance;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  angleFrom
    //----------------------------------

    [Inspectable(category="General")]

    /** 
     *  The starting angle of rotation of the target object,
     *  in degrees.
     *  Valid values range from 0 to 360.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var angleFrom:Number;

    //----------------------------------
    //  angleTo
    //----------------------------------

    [Inspectable(category="General")]

    /** 
     *  The ending angle of rotation of the target object,
     *  in degrees.
     *  Values can be either positive or negative.
     *
     *  <p>If the value of <code>angleTo</code> is less
     *  than the value of <code>angleFrom</code>,
     *  the target rotates in a counterclockwise direction.
     *  Otherwise, it rotates in clockwise direction.
     *  If you want the target to rotate multiple times,
     *  set this value to a large positive or small negative number.</p>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var angleTo:Number;
    
    //----------------------------------
    //  angleBy
    //----------------------------------

    [Inspectable(category="General")]

    /** 
     *  Degrees by which to rotate the target object. Value
     *  may be negative.
     *
     *  <p>If the value of <code>angleBy</code> is negative,
     *  the target rotates in a counterclockwise direction.
     *  Otherwise, it rotates in clockwise direction.
     *  If you want the target to rotate multiple times,
     *  set this value to a large positive or small negative number.</p>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var angleBy:Number;
            
    //----------------------------------
    //  affectLayout
    //----------------------------------
    [Inspectable(category="General")]
    /** 
     *  Specifies whether the parent container of the effect target 
     *  updates its layout based on changes to the effect target
     *  while the effect plays.
     *
     *  @default true
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var affectLayout:Boolean = true;
   
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    // TODO: Can we remove this override? It exists only to create motionPaths,
    // which we should be able to do somewhere else
    /**
     * @private
     */
    override public function createInstance(target:Object = null):IEffectInstance
    {
        motionPaths = [];
        return super.createInstance(target);
    }
    
    /**
     * @private
     */
    override protected function initInstance(instance:IEffectInstance):void
    {
        if(affectLayout)
        {
            addMotionPath("rotationZ", angleFrom, angleTo, angleBy);
        }
        else
        {
            addPostLayoutMotionPath("postLayoutRotationZ", angleFrom, angleTo, angleBy);
        }
        super.initInstance(instance);
    }    
}
}