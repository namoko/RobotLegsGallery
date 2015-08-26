/**
 * Created by Alix on 26.08.2015.
 */
package com.alix.context
{
import com.alix.view.GalleryView;
import com.alix.view.GalleryViewMediator;

import org.robotlegs.mvcs.Context;

public class ApplicationContext extends Context
{
    public function ApplicationContext()
    {
    }

    override public function startup() : void
    {
        trace ("startup");

        mediatorMap.mapView(GalleryView, GalleryViewMediator);
    }
}
}
