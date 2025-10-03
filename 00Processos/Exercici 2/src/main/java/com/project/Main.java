package com.project;

import java.util.concurrent.*;

public class Main {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(1);
        try {
            CompletableFuture<Double> f1 = CompletableFuture.supplyAsync(() -> {
            System.out.println("F1: Validant dades...");
                // Dada d'exemple
                double conc_H = 0.0000001;
                return conc_H;
            }, executor);
            CompletableFuture<Double> f2 = f1.thenApply(result -> {
                System.out.println("F2: Processant dades...");
                // Càlcul d'exemple
                double pH = -Math.log10(result);
                return pH;
            });
            CompletableFuture<Void> f3 = f2.thenAccept(result -> {
                System.out.println("F3: Resultat final: " + result);
            });
            f3.join();
        } finally {
            executor.shutdown();
        }
    }
}

