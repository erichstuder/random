// see: https://en.wikipedia.org/wiki/Cyclic_redundancy_check#Computation
fn crc16_classic(data: &[u8], polynomial: u16) -> u16 {
    let mut result: u16 = (data[0] as u16) << 8 | data[1] as u16;

    for n in 0..data.len() {
        let mut byte: u8;

        if n < data.len()-2 {
            byte = data[n+2];
        } else {
            byte = 0x00;
        }
        for _ in 0..8 {
            let msb_is_set = result & 0x8000 > 0;

            result <<= 1;
            if byte & 0x80 > 0 {
                result |= 0x01;
            }
            byte <<= 1;

            if msb_is_set {
                result ^= polynomial;
            }
        }
    }
    result
}

// see: D.3.2 in https://io-link.com/share/Downloads/System-Extensions/IO-Link_Safety_System-Extensions_10092_V113_Mar22.pdf
fn crc16_running(data: &[u8], polynomial: u16) -> u16 {
    let mut result: u16 = 0;
    for &byte in data.iter() {
        let mut byte = byte;
        for _ in 0..8 {
            let msb_is_different = ((result & 0x8000) > 0) != ((byte & 0x80) > 0);

            result <<= 1;

            if msb_is_different {
                result ^= polynomial;
            }

            byte <<= 1;
        }
    }
    result
}

fn main() {
    let polynomial: u16 = 0x4EAB;
    let data: [u8; 3] = [0x12, 0xAA, 0x69];

    let crc16_classic= crc16_classic(&data, polynomial);
    let crc16_running = crc16_running(&data, polynomial);
    println!("CRC16 Classic: 0b{:016b}", crc16_classic);
    println!("CRC16 Running: 0b{:016b}", crc16_running);
    println!("CRC16 Classic: 0x{:02X}", crc16_classic);
    println!("CRC16 Running: 0x{:02X}", crc16_running);
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_crc_algorithms() {
        let polynomial: u16 = 0x4EAB;
        for a in 0..=255 {
            for b in (0..=255).step_by(3) {
                for c in (0..=255).step_by(7) {
                    for d in (0..=255).step_by(13) {
                        let data: [u8; 4] = [a, b, c, d];
                        let crc_classic = crc16_classic(&data, polynomial);
                        let crc_running = crc16_running(&data, polynomial);
                        assert_eq!(crc_classic, crc_running, "CRC16 Classic and Running should match");
                    }
                }
            }
        }
    }
}
