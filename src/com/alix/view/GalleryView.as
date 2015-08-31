package com.alix.view
{
import com.alix.event.ImageLoadEvent;
import com.alix.factory.GalleryImageFactory;
import com.alix.factory.ImageFactory;

import flash.display.DisplayObject;

import flash.events.MouseEvent;

import mx.containers.Canvas;
import mx.controls.scrollClasses.ScrollBar;

import mx.events.ResizeEvent;

public class GalleryView extends Canvas
{
    private static const GAP:int = 10;
    private static const MIN_ROW_HEIGHT:Number = 150;
    private static const MAX_ROW_HEIGHT:Number = 300;

    private var factory:ImageFactory;

    private var images:Vector.<IGalleryImage>;

    public function GalleryView()
    {
        factory = new GalleryImageFactory();

        images = new <IGalleryImage>[];
        addEventListener(ResizeEvent.RESIZE, onResize);
    }

    private function onResize(e:ResizeEvent):void
    {
        doLayout();
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {

        super.updateDisplayList(unscaledWidth, unscaledHeight);
        graphics.clear();
        graphics.beginFill(0, 0);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
    }

    /**
     * Clears current images and creates all images from list
     * @param imageList
     */
    public function createImages(imageList:Vector.<String>):void
    {
        while (numChildren > 0) removeChildAt(0);

        for each (var url in imageList)
        {
            createOne(url);
        }

        doLayout();
    }

    /**
     * Creates one image and adds it to current
     * @param url
     */
    public function createImage(url:String):void
    {
        createOne(url);

        doLayout();
    }

    private function createOne(url:String):IGalleryImage
    {
        var image:IGalleryImage = factory.create();

        image.source = url;

        image.addEventListener(ImageLoadEvent.IMAGE_LOAD_COMPLETE, onImageLoadComplete);
        image.addEventListener(MouseEvent.CLICK, onImageClick);

        images.push(image);
        addChild(image as DisplayObject);

        return image;
    }

    private function onImageLoadComplete(e:ImageLoadEvent):void
    {
        doLayout();
    }

    private function onImageClick(e:MouseEvent):void
    {
        var image = e.currentTarget as IGalleryImage;
        if (image == null) return;

        image.removeEventListener(MouseEvent.CLICK, onImageClick);
        image.addEventListener(ImageLoadEvent.IMAGE_HIDDEN, onImageHide);

        image.hide();
    }

    private function onImageHide(e:ImageLoadEvent):void
    {
        var image = e.currentTarget as IGalleryImage;
        if (image == null) return;

        image.removeEventListener(ImageLoadEvent.IMAGE_HIDDEN, onImageHide);
        image.dispose();

        var index = images.indexOf(image);

        images.splice(index, 1);
        removeChild(image as DisplayObject);

        doLayout();

        dispatchEvent(new ImageLoadEvent(ImageLoadEvent.LOAD_IMAGE));
    }

    private function doLayout():void
    {
        var idealRowHeight = getIdealRowHeight();

        var imagesInRow:Vector.<GalleryImage> = new <GalleryImage>[];
        var rowWidth:Number = 0;
        var positionY:Number = 0;

        for each(var image in images)
        {
            var relativeWidth = image.calculateRelativeWidth(idealRowHeight);
            if (imagesInRow.length > 0 && rowWidth + relativeWidth + GAP > width) //row overflow
            {
                //scale previous row
                var newRowHeight:Number = resizeRowToWidth(imagesInRow, positionY);
                positionY += newRowHeight + GAP;

                //create new row
                rowWidth = 0;
                imagesInRow.length = 0;
            }

            imagesInRow.push(image);
            rowWidth += relativeWidth + GAP;
        }

        //layout rest images
        resizeRowToWidth(imagesInRow, positionY);
    }

    /**
     * Lays out images
     * @param imagesInRow - images to layout
     * @param positionY - vertical position of images
     * @return new row height after layout
     */
    private function resizeRowToWidth(imagesInRow:Vector.<GalleryImage>, positionY:Number):Number
    {
//        if (imagesInRow.length == 1)
//        {
//            var width:Number = getAvailableWidth();
//
//            var first:GalleryImage = imagesInRow[0];
//            var height = first.calculateRelativeHeight(width);
//            first.moveAndResizeHeight(0, positionY, height);
//
//            return height;
//        }


        var idealRowHeight = getIdealRowHeight();

        var takenWidth = 0;

        for each(var image:GalleryImage in imagesInRow)
        {
            var relativeWidth = image.calculateRelativeWidth(idealRowHeight);
            takenWidth += relativeWidth;
        }

        var widthToTake = getAvailableWidth() - (imagesInRow.length - 1) * GAP;

        var newRowHeight = Math.min(MAX_ROW_HEIGHT, idealRowHeight * widthToTake / takenWidth);
        var positionX:Number = 0;

        for each(var rowImage in imagesInRow)
        {
            var width = rowImage.calculateRelativeWidth(newRowHeight);
            rowImage.moveAndResizeWidth(positionX, positionY, width);

            positionX += width + GAP;
        }

        return newRowHeight;
    }

    private function getIdealRowHeight():Number
    {
        return Math.min(MAX_ROW_HEIGHT, Math.max(MIN_ROW_HEIGHT, height / 4));
    }

    private function getAvailableWidth():Number
    {
        return width - ScrollBar.THICKNESS;
    }
}
}
