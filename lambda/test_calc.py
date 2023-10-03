import unittest
from calculator import *


class BinaryTestOperation(unittest.TestCase):
    def test_addition(self):
        self.assertEqual(calculate ("add", 2, 3), [5,HTTP_OK])
    def test_subtract(self):
        self.assertEqual(calculate ("subtract", 3, 3), [0,HTTP_OK])
    def test_multiply(self):
        self.assertEqual(calculate ("multiply", 2, 3), [6,HTTP_OK])
    def test_divide(self):
        self.assertEqual(calculate ("divide", 25, 5), [5,HTTP_OK])
    def test_divzero(self): 
        self.assertRaises(ZeroDivisionError, calculate,"divide", 1,0)
    def test_mod(self):
        self.assertEqual(calculate ("mod", 10, 3), [1,200])
    def test_pow(self):
        self.assertEqual(calculate ("pow", 5, 5), [3125,HTTP_OK])
    def test_unimplemented_operation(self):
        self.assertEqual(calculate (FAKE, 5, 5), [UNSUPPORTED+FAKE,HTTP_ERROR] )
    

if __name__ == "__main__":
    unittest.main()
