#include <stdio.h>
#include <stdlib.h>
#include <complex.h>  // Complex number library
#include <math.h>

#define WIDTH 800
#define HEIGHT 800

int mandelbrot_recursive(double complex c, double complex z, int n, int max_iter) {
    if (cabs(z) > 2.0 || n == max_iter)
        return n;
    return mandelbrot_recursive(c, z*z + c, n + 1, max_iter);
}

void compute_mandelbrot(double xmin, double xmax, double ymin, double ymax, int width, int height, int max_iter) {
    double dx = (xmax - xmin) / width;
    double dy = (ymax - ymin) / height;

    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            double real = xmin + i * dx;
            double imag = ymin + j * dy;
            double complex c = real + imag * I;

            int value = mandelbrot_recursive(c, 0 + 0 * I, 0, max_iter);

            if (value == max_iter) {
                printf(".");  
            } else {
                printf(" "); 
            }
        }
        printf("\n");
    }
}

int main() {
    double xmin = -2.0, xmax = 1.0, ymin = -1.5, ymax = 1.5;
    int max_iter = 256;

    compute_mandelbrot(xmin, xmax, ymin, ymax, WIDTH, HEIGHT, max_iter);

    return 0;
}
