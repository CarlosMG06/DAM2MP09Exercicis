package com.project;

import java.util.concurrent.*;

public class Main {

    private static final int MAX_CAPACITAT = 3;
    private static final int NUM_COTXES = 8;

    public static void main(String[] args) throws InterruptedException {
        ParkingLot parkingLot = new ParkingLot(MAX_CAPACITAT);

        ExecutorService executor = Executors.newFixedThreadPool(NUM_COTXES);

        for (int i = 1; i <= NUM_COTXES; i++) {
            executor.execute(carTask(i, parkingLot));
        }

        executor.shutdown();
    }

    private static Runnable carTask(int id, ParkingLot parkingLot) {
        return () -> {
            try {
                parkingLot.entrarCotxe(id);
                Thread.sleep((int) (Math.random() * 2000 + 1000)); // Simula temps d'estada
                parkingLot.sortirCotxe(id);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };
    }
}

class ParkingLot {
    private final Semaphore semaphore;

    public ParkingLot(int capacitat) {
        this.semaphore = new Semaphore(capacitat);
    }

    public void entrarCotxe(int id) throws InterruptedException {
        if (!semaphore.tryAcquire()) {
            System.out.println("Cotxe" + id + " espera: aparcament ple.");
            semaphore.acquire();
        }
        System.out.println("Cotxe" + id + " ha entrat a l'aparcament.");
    }

    public void sortirCotxe(int id) {
        semaphore.release();
        System.out.println("Cotxe" + id + " ha sortit de l'aparcament.");
    }
}