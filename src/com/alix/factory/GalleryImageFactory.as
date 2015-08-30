package com.alix.factory
{
import com.alix.view.GalleryImage;
import com.alix.view.IGalleryImage;

public class GalleryImageFactory extends ImageFactory
{
    public override function create() : IGalleryImage
    {
        return new GalleryImage();
    }
}
}
