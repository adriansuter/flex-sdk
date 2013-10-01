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
package spark.components
{

import mx.collections.ICollectionView;
import mx.collections.ISort;
import mx.collections.ISortField;
import mx.core.ClassFactory;
import mx.core.ScrollPolicy;
import mx.core.mx_internal;

import spark.collections.Sort;
import spark.components.supportClasses.IPartRendererDescriptor;
import spark.components.supportClasses.MobileGridColumn;
import spark.components.supportClasses.MobileGridHeader;
import spark.components.supportClasses.MobileGridRowRenderer;
import spark.events.MobileGridHeaderEvent;
import spark.layouts.VerticalLayout;
import spark.layouts.supportClasses.LayoutBase;

use namespace  mx_internal;

/**
 *  Dispatched when the user releases the mouse button on a column header
 *  to request the control to sort  the grid contents based on the contents of the column.
 *  Only dispatched if the column is sortable and the data provider supports
 *  sorting. The DataGrid control has a default handler for this event that implements
 *  a single-column sort.
 * <b>Note</b>: The sort arrows are defined by the default event handler for
 * the headerRelease event. If you call the <code>preventDefault()</code> method
 * in your event handler, the arrows are not drawn.
 * </p>
 *
 *  @eventType mx.events.DataGridEvent.HEADER_RELEASE
 *
 *  @langversion 3.0
 *  @playerversion AIR 3.8
 *  @productversion Flex 4.11
 */
[Event(name="sortChange", type="spark.events.MobileGridHeaderEvent")]

/**
 *  The MobileGrid displays a collection of items in a grid of rows and columns, with column headers, optimized for mobile devices.
 * <p> The MobileGrid component provides the following features:    </p>
 *  <ul>
 *      <li> user can swipe through the rows in the datagrid. </li>
 *      <li> supports single selection of a row. </li>
 *      <li> rows can be sorted according to a given column by clicking on the column's header. </li>
 *      <li> cells can be displayed as text in different fonts and formats, as images, or using a custom renderer. </li>
 *      <li> default  skin uses dark shades of gray, and is available in different screen densities.</li>
 *  </ul>
 *
 * <p> It's important to understand that MobileGrid does not have all the capabilities and flexibility of it's desktop equivalent,
 * in order to ensure optimal display and scrolling performance on mobile devices. </p>
 * <p>Typically, the following features are not available in MobileGrid: </p>
 * <ul>
 *     <li>the list of columns is static and cannot be changed at runtime</li>
 *     <li>multiple selection is not supported </li>
 *     <li>it's not possible to interactively reorder columns </li>
 *     <li>custom cell renderers must be designed with care, preferably in ActionScript, to ensure good display performance </li>
 *   </ul>
 *
 * <p>Internally,  MobileGrid inherits for Mobile spark.List component rather than any Grid or DataGrid, which means that all cell renderers in a single row are managed
 * by one single MobileGridRowRenderer that  delegates the individual  cell renderers to light-weight sub-renderers. </p>
 * <p> You usually don't access this internal row renderer yourself, and will rather define the individual cell renderers.</p>
 * <p> This technique ensures optimal display and memory performance, which is critical for mobile devices,, at the price of less flexibility for cell renderers </p>
 *
 *  @see spark.components.supportClasses.MobileGridColumn
 *
 *  @langversion 3.0
 *  @playerversion AIR 3.8
 *  @productversion Flex 4.11
 */
public class MobileGrid extends List
{

    [SkinPart(required="true")]
    public var headerGroup:MobileGridHeader;

    private var _columns: Array;
    private var _columnsChanged:Boolean = false;
    private var _sortableColumns:Boolean = true;
    private var lastSortIndex:int = -1;
    private var sortIndex:int = -1;
    private var sortColumn:MobileGridColumn;

    public function MobileGrid()
    {
        layout = getDefaultLayout();
        scrollSnappingMode = ScrollSnappingMode.LEADING_EDGE;
        setStyle("horizontalScrollPolicy", ScrollPolicy.OFF);
        useVirtualLayout = true;
        columns = [];
    }

    /**
     *  An array of MobileGridColumn objects, one for each column that  can be displayed.
     *  <p>Contrary to desktop DataGrid, this property must be set explicitly , or no columns will be displayed.</p>
     *  <p>If you want to change the set of columns,you need to re-assign the new array to the columns property.
     *  Changes to the original array without assigning the property will have no effect.</p>
     *
     *  @see   spark.components.supportClasses.MobileGridColumn
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Inspectable(arrayType="spark.components.supportClasses.MobileGridColumn")]
    public function set columns(value:Array):void
    {
        _columns = value;
        _columnsChanged = true;
        invalidateProperties();
        // copy  to vector and set indices
    }

    public function get columns():Array
    {
        return _columns.concat();
    }

    /**
     *  A flag that indicates whether the user can sort the rows
     *  by clicking on a column header cell.
     *  If <code>true</code>, the user can sort the data provider items by
     *  clicking on a column header cell.
     *  If <code>true</code>, individual columns can be made to not respond
     *  to a click on a header by setting the column's <code>sortable</code>
     *  property to <code>false</code>.
     *
     *  <p>When a user releases the mouse button over a header cell, the DataGrid
     *  control dispatches a <code>headerRelease</code> event if both
     *  this property and the column's sortable property are <code>true</code>.
     *  If no handler calls the <code>preventDefault()</code> method on the event, the
     *  DataGrid sorts using that column's <code>MobileGridColumn.dataField</code> or
     *  <code>MobileGridColumn.labelFunction</code> properties.</p>
     *
     *  @default true
     *
     *  @see spark.components.supportClasses.MobileGridColumn#sortable
     *
     *  @langversion 3.0
     *  @playerversion AIR 3.8
     *  @productversion Flex 4.11
     */
    public function get sortableColumns():Boolean
    {
        return _sortableColumns && (dataProvider is ICollectionView);
    }

    public function set sortableColumns(value:Boolean):void
    {
        _sortableColumns = value;
    }

    override protected function commitProperties():void
    {
        super.commitProperties();
        if (_columnsChanged){
            _columnsChanged = false;
            for (var i:int = 0; i < _columns.length; i++)
            {
                MobileGridColumn(_columns[i]).colNum = i;
            }
            initDefaultItemRenderer(_columns);
            if (headerGroup)
                headerGroup.columns = _columns;
        }
    }

    /* default layout for row item renderers */
    protected function getDefaultLayout():LayoutBase
    {
        var l:VerticalLayout = new VerticalLayout();
        l.horizontalAlign = "contentJustify";
        l.gap = 0;
        return l;
    }

    protected function initDefaultItemRenderer(pcolumnDescriptors: Array):void
    {
        var cf:ClassFactory;
        cf = new ClassFactory(MobileGridRowRenderer);
        cf.properties = {
            partRendererDescriptors: Vector.<IPartRendererDescriptor>(pcolumnDescriptors)
        };
        this.itemRenderer = cf;
    }

    override protected function partAdded(partName:String, instance:Object):void
    {
        if (instance === headerGroup)
        {
            headerGroup.dataGrid = this;
            headerGroup.columns = _columns;
            headerGroup.addEventListener(MobileGridHeaderEvent.SORT_CHANGE, headerGroup_sortChangeHandler);
        }
        super.partAdded(partName, instance);
    }

    override protected function partRemoved(partName:String, instance:Object):void
    {
        if (instance === headerGroup)
        {
            headerGroup.columns = null;
            headerGroup.removeEventListener(MobileGridHeaderEvent.SORT_CHANGE, headerGroup_sortChangeHandler);
        }
        super.partRemoved(partName, instance);
    }


    private function headerGroup_sortChangeHandler(event:MobileGridHeaderEvent):void
    {
        var e:MobileGridHeaderEvent = MobileGridHeaderEvent(event.clone());
        dispatchEvent( e)
        if (!e.isDefaultPrevented())
        {
                 sortByColumn(e.columnIndex);
        }
    }

    /* roughly same behavior as mx:DataGrid */
    private function sortByColumn(index:int):void
    {
        var collection:ICollectionView = dataProvider as ICollectionView;
        var c:MobileGridColumn = _columns[index];
        if (!c.sortable)
            return ;
        var desc:Boolean = c.sortDescending;

        // do the sort if we're allowed to
        if (collection == null)
            return;

        var s:ISort = collection.sort;
        var f:ISortField;

        if (s)
        {
            s.compareFunction = null;
            // analyze the current sort to see what we've been given
            var sf:Array = s.fields;
            if (sf)
            {
                for (var i:int = 0; i < sf.length; i++)
                {

                    if (sf[i].name == c.dataField)
                    {
                        // we're part of the current sort
                        f = sf[i];
                        // flip the logic so desc is new desired order
                        desc = !f.descending;
                        break;
                    }
                }
            }
        }
        else
            s = new Sort();

        if (!f)
            f = c.sortField;

        c.sortDescending = desc;

        // set the grid's sortIndex
        lastSortIndex = sortIndex;
        sortIndex = index;
        sortColumn = c;
        f.name = c.dataField;
        f.descending = desc;
        s.fields = [f];
        collection.sort = s;
        collection.refresh();

        // update header
        headerGroup.setSort(sortIndex, desc);
    }



}
}