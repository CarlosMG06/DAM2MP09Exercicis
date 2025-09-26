package com.project;

import java.util.concurrent.*;

public class Main {

    public static void main(String[] args) throws InterruptedException {
        ExecutorService executor = Executors.newFixedThreadPool(2);

        Runnable registrarEsdeveniment = () -> {
            try {
                System.out.println("Registrant esdeveniment...");
                Thread.sleep(2000);
                System.out.println("Esdeveniment registrat.");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };

        // Tasca 2: modificar (consumeix 100 i publica 200)
        Runnable comprovarEstatDeXarxa = () -> {
            try {
                System.out.println("Comprovant estat de xarxa...");
                Thread.sleep(500);
                System.out.println("Estat de xarxa comprovat.");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };

        executor.execute(registrarEsdeveniment);
        executor.execute(comprovarEstatDeXarxa);

        executor.shutdown();
        executor.awaitTermination(10, TimeUnit.SECONDS);
    }
}
