/**
 * Created by Alix on 26.08.2015.
 */
package com.alix.view
{
import org.robotlegs.mvcs.Mediator;

public class GalleryViewMediator extends Mediator
{

    [Inject]
    public var view : GalleryView;

    override public function onRegister():void
    {
        trace("GalleryViewMediator registered")
    }
}
}
