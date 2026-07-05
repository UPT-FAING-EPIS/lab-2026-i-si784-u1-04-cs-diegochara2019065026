namespace Shorten.Areas.Domain;

/// <summary>
/// Represents a shortened URL mapping.
/// </summary>
public class UrlMapping
{
    /// <summary>
    /// Gets or sets the mapping identifier.
    /// </summary>
    public int Id { get; set; }

    /// <summary>
    /// Gets or sets the original long URL.
    /// </summary>
    public string OriginalUrl { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the shortened URL.
    /// </summary>
    public string ShortenedUrl { get; set; } = string.Empty;
}
