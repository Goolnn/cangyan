use flutter_rust_bridge::frb;

#[frb(non_opaque)]
pub struct Date {
    pub year: u16,
    pub month: u8,
    pub day: u8,
    pub hour: u8,
    pub minute: u8,
    pub second: u8,
}

impl From<cyfile::Date> for Date {
    fn from(date: cyfile::Date) -> Self {
        Date {
            year: date.year(),
            month: date.month(),
            day: date.day(),
            hour: date.hour(),
            minute: date.minute(),
            second: date.second(),
        }
    }
}
