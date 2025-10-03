package com.project;

import java.util.concurrent.*;

public class Main {

    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(3);

        ConcurrentHashMap<String, Integer> parcials = new ConcurrentHashMap<>();

        CyclicBarrier barrier = new CyclicBarrier(3, () -> {
            int resultatFinal = parcials.values().stream().mapToInt(Integer::intValue).sum();
            System.out.println("Totes les tasques han acabat. Combinant resultats...");
            System.out.println("Parcials: " + parcials);
            System.out.println("Resultat final: " + resultatFinal);
        });

        Runnable microservei1 = () -> {
            try {
                System.out.println("Microservei 1 processant dades...");
                Thread.sleep(1000);
                parcials.put("parcial_1", 10); 
                System.out.println("Microservei 1 ha acabat.");
                barrier.await();
            } catch (InterruptedException | BrokenBarrierException e) {
                Thread.currentThread().interrupt();
            }
        };

        Runnable microservei2 = () -> {
            try {
                System.out.println("Microservei 2 processant dades...");
                Thread.sleep(1500);
                parcials.put("parcial_2", 20);
                System.out.println("Microservei 2 ha acabat.");
                barrier.await();
            } catch (InterruptedException | BrokenBarrierException e) {
                Thread.currentThread().interrupt();
            }
        };

        Runnable microservei3 = () -> {
            try {
                System.out.println("Microservei 3 processant dades...");
                Thread.sleep(500);
                parcials.put("parcial_3", 30);
                System.out.println("Microservei 3 ha acabat.");
                barrier.await();
            } catch (InterruptedException | BrokenBarrierException e) {
                Thread.currentThread().interrupt();
            }
        };

        executor.execute(microservei1);
        executor.execute(microservei2);
        executor.execute(microservei3);

        executor.shutdown();
    }
}
