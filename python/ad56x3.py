"""
Project: drvAd56x3

Author: Kuznetcov Andrey, andky@inbox.ru
 
TODO:
    
DESCRIPTION:
    Class for ad56x3 DAC series driver
"""
from device import Device
from enum import IntEnum
import numpy as np

# Варианты сигналов выводимых на ЦАП
class DacSource(IntEnum):
    INTERFACE = 0
    SAW_GENERAOR = 1

# Порядок каналов
class ChanOrder(IntEnum):
    NORMAL = 0
    SWAPPED = 1

class Ad56x3(Device):
    """
        Таблица управляющих регистров
        Адрес   Биты	Чтение/запись	Описание
        0	    0	    w	            Сброс всех регистров в значения по-умолчанию
        1	    0	    w/r	            0 - данные на ЦАП с внешнего интерфейса, 1 - данные с генератора
        2	    0	    w/r	            0 - стандартное расположение каналов, 1 - переключение каналов
        3	    [15:0]	w/r	            Установка делителя частоты для генератора(частота дискретизации)
        4	    [15:0]	w/r	            Значение приращения (знаковое число) для генератора, канал 0
        5	    [15:0]	w/r	            Значение приращения (знаковое число) для генератора, канал 1
    """
    REG_CTRL        = 0
    REG_DACSRC      = 2
    REG_CHANORDER   = 4
    REG_FSDIV       = 6
    REG_DELTA0      = 8
    REG_DELTA1      = 10
     
    def reset(self):
        self.write_16(self.REG_CTRL, 0x0001)
             
    def setDacSource(self, dacSource):
        self.write_16(self.REG_DACSRC, int(dacSource))
    
    def setChanOrder(self, chanOdrer):
        self.write_16(self.REG_CHANORDER, int(chanOdrer))
      
    def setDivider(self, divider):
        self.write_16(self.REG_FSDIV, int(divider))
    
    def setDeltas(self, deltas):
        if len(deltas) == 2:
            self.write_16(self.REG_DELTA0, int(deltas[0]))
            self.write_16(self.REG_DELTA1, int(deltas[1]))
        else:
            self.write_16(self.REG_DELTA0, int(deltas))
            self.write_16(self.REG_DELTA1, int(deltas))      
       
    def getDacSource(self):       
        return DacSource(self.read_16(self.REG_DACSRC) & 1) 

    def getChanOrder(self):       
        return ChanOrder(self.read_16(self.REG_CHANORDER) & 1) 

    def getDivider(self):       
        return self.read_16(self.REG_FSDIV) 

    def getDeltas(self):       
        return (np.int16(self.read_16(self.REG_DELTA0)), np.int16(self.read_16(self.REG_DELTA1)) 
