import Foundation

struct WorldTimeData {
    static let timeZones: [TimeZoneModel] = [
        // UTC Zones
        TimeZoneModel(id: "UTC", identifier: "UTC", displayName: "UTC (Coordinated Universal Time)", abbreviation: "UTC", offsetSeconds: 0),
        
        // Africa
        TimeZoneModel(id: "Africa/Cairo", identifier: "Africa/Cairo", displayName: "Cairo", abbreviation: "EET", offsetSeconds: 7200),
        TimeZoneModel(id: "Africa/Johannesburg", identifier: "Africa/Johannesburg", displayName: "Johannesburg", abbreviation: "SAST", offsetSeconds: 7200),
        TimeZoneModel(id: "Africa/Lagos", identifier: "Africa/Lagos", displayName: "Lagos", abbreviation: "WAT", offsetSeconds: 3600),
        TimeZoneModel(id: "Africa/Nairobi", identifier: "Africa/Nairobi", displayName: "Nairobi", abbreviation: "EAT", offsetSeconds: 10800),
        TimeZoneModel(id: "Africa/Addis_Ababa", identifier: "Africa/Addis_Ababa", displayName: "Addis Ababa (Ethiopia)", abbreviation: "EAT", offsetSeconds: 10800),
        TimeZoneModel(id: "Africa/Casablanca", identifier: "Africa/Casablanca", displayName: "Casablanca", abbreviation: "WET", offsetSeconds: 0),
        TimeZoneModel(id: "Africa/Dar_es_Salaam", identifier: "Africa/Dar_es_Salaam", displayName: "Dar es Salaam", abbreviation: "EAT", offsetSeconds: 10800),
        TimeZoneModel(id: "Africa/Accra", identifier: "Africa/Accra", displayName: "Accra", abbreviation: "GMT", offsetSeconds: 0),
        TimeZoneModel(id: "Africa/Kigali", identifier: "Africa/Kigali", displayName: "Kigali", abbreviation: "CAT", offsetSeconds: 7200),
        
        // Americas
        TimeZoneModel(id: "America/New_York", identifier: "America/New_York", displayName: "New York", abbreviation: "EST", offsetSeconds: -18000),
        TimeZoneModel(id: "America/Chicago", identifier: "America/Chicago", displayName: "Chicago", abbreviation: "CST", offsetSeconds: -21600),
        TimeZoneModel(id: "America/Denver", identifier: "America/Denver", displayName: "Denver", abbreviation: "MST", offsetSeconds: -25200),
        TimeZoneModel(id: "America/Los_Angeles", identifier: "America/Los_Angeles", displayName: "Los Angeles", abbreviation: "PST", offsetSeconds: -28800),
        TimeZoneModel(id: "America/Anchorage", identifier: "America/Anchorage", displayName: "Anchorage", abbreviation: "AKST", offsetSeconds: -32400),
        TimeZoneModel(id: "Pacific/Honolulu", identifier: "Pacific/Honolulu", displayName: "Honolulu", abbreviation: "HST", offsetSeconds: -36000),
        TimeZoneModel(id: "America/Toronto", identifier: "America/Toronto", displayName: "Toronto", abbreviation: "EST", offsetSeconds: -18000),
        TimeZoneModel(id: "America/Mexico_City", identifier: "America/Mexico_City", displayName: "Mexico City", abbreviation: "CST", offsetSeconds: -21600),
        TimeZoneModel(id: "America/Buenos_Aires", identifier: "America/Buenos_Aires", displayName: "Buenos Aires", abbreviation: "ART", offsetSeconds: -10800),
        TimeZoneModel(id: "America/Sao_Paulo", identifier: "America/Sao_Paulo", displayName: "São Paulo", abbreviation: "BRT", offsetSeconds: -10800),
        TimeZoneModel(id: "America/Lima", identifier: "America/Lima", displayName: "Lima", abbreviation: "PET", offsetSeconds: -18000),
        
        // Europe
        TimeZoneModel(id: "Europe/London", identifier: "Europe/London", displayName: "London", abbreviation: "GMT", offsetSeconds: 0),
        TimeZoneModel(id: "Europe/Paris", identifier: "Europe/Paris", displayName: "Paris", abbreviation: "CET", offsetSeconds: 3600),
        TimeZoneModel(id: "Europe/Berlin", identifier: "Europe/Berlin", displayName: "Berlin", abbreviation: "CET", offsetSeconds: 3600),
        TimeZoneModel(id: "Europe/Madrid", identifier: "Europe/Madrid", displayName: "Madrid", abbreviation: "CET", offsetSeconds: 3600),
        TimeZoneModel(id: "Europe/Rome", identifier: "Europe/Rome", displayName: "Rome", abbreviation: "CET", offsetSeconds: 3600),
        TimeZoneModel(id: "Europe/Amsterdam", identifier: "Europe/Amsterdam", displayName: "Amsterdam", abbreviation: "CET", offsetSeconds: 3600),
        TimeZoneModel(id: "Europe/Brussels", identifier: "Europe/Brussels", displayName: "Brussels", abbreviation: "CET", offsetSeconds: 3600),
        TimeZoneModel(id: "Europe/Vienna", identifier: "Europe/Vienna", displayName: "Vienna", abbreviation: "CET", offsetSeconds: 3600),
        TimeZoneModel(id: "Europe/Prague", identifier: "Europe/Prague", displayName: "Prague", abbreviation: "CET", offsetSeconds: 3600),
        TimeZoneModel(id: "Europe/Moscow", identifier: "Europe/Moscow", displayName: "Moscow", abbreviation: "MSK", offsetSeconds: 10800),
        TimeZoneModel(id: "Europe/Istanbul", identifier: "Europe/Istanbul", displayName: "Istanbul", abbreviation: "EET", offsetSeconds: 7200),
        TimeZoneModel(id: "Europe/Athens", identifier: "Europe/Athens", displayName: "Athens", abbreviation: "EET", offsetSeconds: 7200),
        
        // Asia
        TimeZoneModel(id: "Asia/Dubai", identifier: "Asia/Dubai", displayName: "Dubai", abbreviation: "GST", offsetSeconds: 14400),
        TimeZoneModel(id: "Asia/Bangkok", identifier: "Asia/Bangkok", displayName: "Bangkok", abbreviation: "ICT", offsetSeconds: 25200),
        TimeZoneModel(id: "Asia/Singapore", identifier: "Asia/Singapore", displayName: "Singapore", abbreviation: "SGT", offsetSeconds: 28800),
        TimeZoneModel(id: "Asia/Hong_Kong", identifier: "Asia/Hong_Kong", displayName: "Hong Kong", abbreviation: "HKT", offsetSeconds: 28800),
        TimeZoneModel(id: "Asia/Tokyo", identifier: "Asia/Tokyo", displayName: "Tokyo", abbreviation: "JST", offsetSeconds: 32400),
        TimeZoneModel(id: "Asia/Shanghai", identifier: "Asia/Shanghai", displayName: "Shanghai", abbreviation: "CST", offsetSeconds: 28800),
        TimeZoneModel(id: "Asia/Kolkata", identifier: "Asia/Kolkata", displayName: "Delhi", abbreviation: "IST", offsetSeconds: 19800),
        TimeZoneModel(id: "Asia/Seoul", identifier: "Asia/Seoul", displayName: "Seoul", abbreviation: "KST", offsetSeconds: 32400),
        TimeZoneModel(id: "Asia/Jakarta", identifier: "Asia/Jakarta", displayName: "Jakarta", abbreviation: "WIB", offsetSeconds: 25200),
        TimeZoneModel(id: "Asia/Manila", identifier: "Asia/Manila", displayName: "Manila", abbreviation: "PHT", offsetSeconds: 28800),
        TimeZoneModel(id: "Asia/Karachi", identifier: "Asia/Karachi", displayName: "Karachi", abbreviation: "PKT", offsetSeconds: 18000),
        TimeZoneModel(id: "Asia/Yangon", identifier: "Asia/Yangon", displayName: "Yangon", abbreviation: "MMT", offsetSeconds: 23400),
        
        // Oceania
        TimeZoneModel(id: "Australia/Sydney", identifier: "Australia/Sydney", displayName: "Sydney", abbreviation: "AEDT", offsetSeconds: 39600),
        TimeZoneModel(id: "Australia/Melbourne", identifier: "Australia/Melbourne", displayName: "Melbourne", abbreviation: "AEDT", offsetSeconds: 39600),
        TimeZoneModel(id: "Australia/Brisbane", identifier: "Australia/Brisbane", displayName: "Brisbane", abbreviation: "AEST", offsetSeconds: 36000),
        TimeZoneModel(id: "Australia/Perth", identifier: "Australia/Perth", displayName: "Perth", abbreviation: "AWST", offsetSeconds: 28800),
        TimeZoneModel(id: "Pacific/Auckland", identifier: "Pacific/Auckland", displayName: "Auckland", abbreviation: "NZDT", offsetSeconds: 46800),
        TimeZoneModel(id: "Pacific/Fiji", identifier: "Pacific/Fiji", displayName: "Fiji", abbreviation: "FJT", offsetSeconds: 43200),
    ]
}
