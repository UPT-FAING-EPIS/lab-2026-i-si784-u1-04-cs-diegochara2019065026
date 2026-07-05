using Shorten.Areas.Domain;

namespace Shorten.Tests;

public class UrlMappingTests
{
    [Test]
    public void UrlMapping_StoresOriginalAndShortenedUrl()
    {
        UrlMapping mapping = new UrlMapping
        {
            Id = 1,
            OriginalUrl = "https://example.com/a/very/long/url",
            ShortenedUrl = "https://sho.rt/abc"
        };

        Assert.That(mapping.Id, Is.EqualTo(1));
        Assert.That(mapping.OriginalUrl, Does.Contain("example.com"));
        Assert.That(mapping.ShortenedUrl, Is.EqualTo("https://sho.rt/abc"));
    }
}
