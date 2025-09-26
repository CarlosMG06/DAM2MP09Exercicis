package com.project;

import java.util.concurrent.*;

public class Main {

    public static void main(String[] args) throws InterruptedException {
        ConcurrentHashMap<String, Double> dades = new ConcurrentHashMap<>();

        ExecutorService executor = Executors.newFixedThreadPool(3);

        Runnable recepcioOperacio = () -> {
            System.out.println("Rebent operacio bancaria...");
            dades.put("saldo", 1000.0);
            dades.put("interes", 0.05);
            System.out.println("Saldo inicial: " + dades.get("saldo") + "$");
        };

        Runnable calculInteres = () -> {
            try {
                System.out.println("Calculant interessos...");
                while (!dades.containsKey("saldo") || !dades.containsKey("interes")) {
                    Thread.sleep(10); // Espera fins que les dades estiguin disponibles
                }
                double saldo = dades.get("saldo");
                double interes = dades.get("interes");
                dades.put("saldo_final", saldo + (saldo * interes));
                System.out.println("Interes aplicat.");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };

        Callable<Double> obtenirSaldoFinal = () -> {
            System.out.println("Obtenint saldo final...");
            while (!dades.containsKey("saldo_final")) {
                Thread.sleep(10); // Espera fins que el saldo calculat estigui disponible
            }
            return dades.get("saldo_final");
        };

        executor.execute(recepcioOperacio);
        executor.execute(calculInteres);
        Future<Double> resultat = executor.submit(obtenirSaldoFinal);

        try {
             System.out.println("Saldo final: " + resultat.get() + "$");
        } catch (ExecutionException e) {
            e.printStackTrace();
        }

        executor.shutdown();
    }
}
