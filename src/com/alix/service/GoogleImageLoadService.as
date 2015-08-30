package com.alix.service
{
import be.boulevart.google.ajaxapi.search.GoogleSearchResult;
import be.boulevart.google.ajaxapi.search.images.GoogleImageSearch;
import be.boulevart.google.ajaxapi.search.images.data.GoogleImage;
import be.boulevart.google.ajaxapi.search.images.data.types.GoogleImageSize;
import be.boulevart.google.events.GoogleAPIErrorEvent;
import be.boulevart.google.events.GoogleApiEvent;

import com.alix.event.ImageLoadEvent;

import com.alix.model.ApplicationModel;

import org.robotlegs.mvcs.Actor;

public class GoogleImageLoadService extends Actor implements IImageLoadService
{
    private static const SEARCH_CRITERIA:String = "Christmas";
    private static const MIN_RESULTS : int = 16;

    [Inject]
    public var model : ApplicationModel;

    private var imageStack:Vector.<String> = new <String>[];

    private var loadingAll : Boolean;
    private var totalLoaded : int;

    public function getImageList()
    {
        loadingAll = true;

        loadImages();
    }

    private function loadImages():void
    {
        var search:GoogleImageSearch=new GoogleImageSearch();

        search.search(SEARCH_CRITERIA, totalLoaded,"en", GoogleImageSize.MEDIUM);
        search.addEventListener(GoogleApiEvent.IMAGE_SEARCH_RESULT, onSearchResults);

        //If you want to catch the API errors yourself:
        //search.addEventListener(GoogleAPIErrorEvent.API_ERROR,onAPIError)
    }

    private function onSearchResults(e:GoogleApiEvent):void
    {
        var resultObject:GoogleSearchResult=e.data as GoogleSearchResult;
        trace("Estimated Number of Results: "+resultObject.estimatedNumResults);
        trace("Current page index: "+resultObject.currentPageIndex);
        trace("Number of pages: "+resultObject.numPages);

        for each (var result:GoogleImage in resultObject.results)
        {
            //trace (result.title, result.url);
            imageStack.push(result.url);
            totalLoaded++;
        }

        if (imageStack.length < MIN_RESULTS)
        {
            // do several requests until stack is full
            loadImages();
            return;
        }

        if (loadingAll)
        {
            var list:Vector.<String> = new <String>[];
            for (var i:int = 0;i<MIN_RESULTS;i++)
            {
                list.push(imageStack.shift());
            }

            model.imageList = list;

            trace("image list parsing complete "+list);
            dispatch(new ImageLoadEvent(ImageLoadEvent.IMAGE_LIST_LOADED));
        }
        else
        {
            getNextImage();
        }
    }

    private function onAPIError(evt:GoogleAPIErrorEvent):void
    {
        trace("An API error has occured: " + evt.responseDetails, "responseStatus was: " + evt.responseStatus);
    }

    private function dispatchOneLoaded(url:String)
    {
        model.imageUrl = url;

        trace("imag url loaded "+url);
        dispatch(new ImageLoadEvent(ImageLoadEvent.IMAGE_LOAD_COMPLETE));
    }

    public function getNextImage()
    {
        if (imageStack.length > 0)
        {
            dispatchOneLoaded(imageStack.shift());
        }
        else
        {
            loadingAll = false;
            loadImages();
        }
    }
}

}
