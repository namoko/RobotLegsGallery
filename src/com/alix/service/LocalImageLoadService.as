package com.alix.service
{
import com.alix.event.ImageLoadEvent;
import com.alix.model.ApplicationModel;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.robotlegs.mvcs.Actor;

public class LocalImageLoadService extends Actor implements IImageLoadService
{
    public static const MAIN_URL = "https://raw.githubusercontent.com/namoko/RobotLegsGallery/master/images/";
    public static const IMAGE_LIST:String = "list.xml";

    [Inject]
    public var model : ApplicationModel;

    public function loadImageList()
    {
        var imageListUrl = MAIN_URL + IMAGE_LIST;

        var loader:URLLoader = new URLLoader();

        loader.addEventListener(IOErrorEvent.IO_ERROR, imageListLoadError);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, imageListLoadError);
        loader.addEventListener(Event.COMPLETE, imageListLoadComplete);

        loader.load(new URLRequest(imageListUrl));
        trace("started load image list from "+imageListUrl);
    }

    private function imageListLoadError(e:Event):void
    {
        trace("imageListLoadError "+e);
        dispatch(new ImageLoadEvent(ImageLoadEvent.IMAGE_LIST_ERROR));
    }

    private function imageListLoadComplete(e:Event):void
    {
        trace("imageListLoadComplete "+e);
        var loader = e.target as URLLoader;
        var data = loader.data;

        var list:Vector.<String> = new <String>[];

        var xml = XML(data);
        for each (var child in xml.children())
        {
            list.push(MAIN_URL + child.toString());
        }

        model.imageList = list;

        trace("image list parsing complete "+list);
        dispatch(new ImageLoadEvent(ImageLoadEvent.IMAGE_LIST_LOADED));
    }

    public function loadImage(imagePath:String)
    {
    }
}
}
