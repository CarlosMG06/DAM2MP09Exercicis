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

        for (int i = 1; i <= 3; i++) {
            executor.execute(microservei(i, parcials, barrier));
        }

        executor.shutdown();
    }

    private static Runnable microservei(int id, ConcurrentHashMap parcials, CyclicBarrier barrier) {
        return () -> {
            try {
                System.out.println("Microservei " + id + " processant dades...");
                Thread.sleep((int) (500 * id));
                parcials.put("parcial_" + id, id * 10);
                System.out.println("Microservei " + id + " ha acabat.");
                barrier.await();
            } catch (InterruptedException | BrokenBarrierException e) {
                Thread.currentThread().interrupt();
            }
        };
    }
}
